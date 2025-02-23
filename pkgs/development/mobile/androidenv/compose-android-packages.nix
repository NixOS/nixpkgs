{ callPackage, stdenv, stdenvNoCC, lib, fetchurl, ruby, writeText
, licenseAccepted ? false, meta
}:

{ repoJson ? ./repo.json
, repoXmls ? null
, repo ? (
  # Reads the repo JSON. If repoXmls is provided, will build a repo JSON into the Nix store.
  if repoXmls != null then
    let
      # Uses mkrepo.rb to create a repo spec.
      mkRepoJson = { packages ? [], images ? [], addons ? [] }: let
        mkRepoRuby = (ruby.withPackages (pkgs: with pkgs; [ slop nokogiri ]));
        mkRepoRubyArguments = lib.lists.flatten [
          (map (package: ["--packages" "${package}"]) packages)
          (map (image: ["--images" "${image}"]) images)
          (map (addon: ["--addons" "${addon}"]) addons)
        ];
      in
      stdenvNoCC.mkDerivation {
        name = "androidenv-repo-json";
        buildInputs = [ mkRepoRuby ];
        preferLocalBuild = true;
        unpackPhase = "true";
        buildPhase = ''
          ruby ${./mkrepo.rb} ${lib.escapeShellArgs mkRepoRubyArguments} > repo.json
        '';
        installPhase = ''
          mv repo.json $out
        '';
      };
       repoXmlSpec = {
         packages = repoXmls.packages or [];
         images = repoXmls.images or [];
         addons = repoXmls.addons or [];
       };
    in
      lib.importJSON "${mkRepoJson repoXmlSpec}"
  else
    lib.importJSON repoJson
  )
, cmdLineToolsVersion ? repo.latest.cmdline-tools
, toolsVersion ? repo.latest.tools
, platformToolsVersion ? repo.latest.platform-tools
, buildToolsVersions ? [ repo.latest.build-tools ]
, includeEmulator ? false
, emulatorVersion ? repo.latest.emulator
, platformVersions ? [ repo.latest.platforms ]
, includeSources ? false
, includeSystemImages ? false
, systemImageTypes ? [ "google_apis" "google_apis_playstore" ]
, abiVersions ? [ "x86" "x86_64" "armeabi-v7a" "arm64-v8a" ]
  # cmake has precompiles on x86_64 and Darwin platforms. Default to true there for compatibility.
, includeCmake ? stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isDarwin
, cmakeVersions ? [ repo.latest.cmake ]
, includeNDK ? false
, ndkVersion ? repo.latest.ndk
, ndkVersions ? [ ndkVersion ]
, useGoogleAPIs ? false
, useGoogleTVAddOns ? false
, includeExtras ? []
, extraLicenses ? []
}:

let
  # Determine the Android os identifier from Nix's system identifier
  os = {
      x86_64-linux = "linux";
      x86_64-darwin = "macosx";
      aarch64-linux = "linux";
      aarch64-darwin = "macosx";
  }.${stdenv.hostPlatform.system} or "all";

  # Determine the Android arch identifier from Nix's system identifier
  arch = {
      x86_64-linux = "x64";
      x86_64-darwin = "x64";
      aarch64-linux = "aarch64";
      aarch64-darwin = "aarch64";
  }.${stdenv.hostPlatform.system} or "all";

  # Converts all 'archives' keys in a repo spec to fetchurl calls.
  fetchArchives = attrSet:
    lib.attrsets.mapAttrsRecursive
      (path: value:
        if (builtins.elemAt path ((builtins.length path) - 1)) == "archives" then
          let
            validArchives = builtins.filter (archive:
              let
                isTargetOs = if builtins.hasAttr "os" archive then
                  archive.os == os || archive.os == "all" else true;
                isTargetArch = if builtins.hasAttr "arch" archive then
                  archive.arch == arch || archive.arch == "all" else true;
              in
                isTargetOs && isTargetArch
            ) value;
          in
          lib.optionals (builtins.length validArchives > 0)
            (lib.last (map (archive:
              (fetchurl { inherit (archive) url sha1; })
            ) validArchives))
        else value
      )
      attrSet;

  # Converts the repo attrset into fetch calls
  packages = fetchArchives repo.packages;
  system-images-packages = fetchArchives repo.images;
  addons = {
    addons = fetchArchives repo.addons;
    extras = fetchArchives repo.extras;
  };

  # Converts a license name to a list of license texts.
  mkLicenses = licenseName: repo.licenses.${licenseName};

  # Converts a list of license names to a flattened list of license texts.
  # Just used for displaying licenses.
  mkLicenseTexts = licenseNames:
    lib.lists.flatten
      (builtins.map
        (licenseName:
          builtins.map
            (licenseText: "--- ${licenseName} ---\n${licenseText}")
            (mkLicenses licenseName))
      licenseNames);

  # Converts a license name to a list of license hashes.
  mkLicenseHashes = licenseName:
    builtins.map
      (licenseText: builtins.hashString "sha1" licenseText)
      (mkLicenses licenseName);

  # The list of all license names we're accepting. Put android-sdk-license there
  # by default.
  licenseNames = lib.lists.unique ([
    "android-sdk-license"
  ] ++ extraLicenses);
in
lib.recurseIntoAttrs rec {
  deployAndroidPackages = callPackage ./deploy-androidpackages.nix {
    inherit stdenv lib mkLicenses meta os arch;
  };

  deployAndroidPackage = ({package, buildInputs ? [], patchInstructions ? "", meta ? {}, ...}@args:
    let
      extraParams = removeAttrs args [ "package" "os" "arch" "buildInputs" "patchInstructions" ];
    in
    deployAndroidPackages ({
      inherit buildInputs;
      packages = [ package ];
      patchesInstructions = { "${package.name}" = patchInstructions; };
    } // extraParams
  ));

  # put a much nicer error message that includes the available options.
  check-version = packages: package: version:
    if lib.hasAttrByPath [ package version ] packages then
      packages.${package}.${version}
    else
      throw ''
        The version ${version} is missing in package ${package}.
        The only available versions are ${builtins.concatStringsSep ", " (builtins.attrNames packages.${package})}.
      '';

  platform-tools = callPackage ./platform-tools.nix {
    inherit deployAndroidPackage os arch meta;
    package = check-version packages "platform-tools" platformToolsVersion;
  };

  tools = callPackage ./tools.nix {
    inherit deployAndroidPackage os arch meta;
    package = check-version packages "tools" toolsVersion;

    postInstall = ''
      ${linkPlugin { name = "platform-tools"; plugin = platform-tools; }}
      ${linkPlugin { name = "emulator"; plugin = emulator; check = includeEmulator; }}
    '';
  };

  build-tools = map (version:
    callPackage ./build-tools.nix {
      inherit deployAndroidPackage os arch meta;
      package = check-version packages "build-tools" version;

      postInstall = ''
        ${linkPlugin { name = "tools"; plugin = tools; check = toolsVersion != null; }}
      '';
    }
  ) buildToolsVersions;

  emulator =
    callPackage ./emulator.nix {
      inherit deployAndroidPackage os arch meta;
      package = check-version packages "emulator" emulatorVersion;

      postInstall = ''
        ${linkSystemImages { images = system-images; check = includeSystemImages; }}
      '';
    };

  platforms = map (version:
    deployAndroidPackage {
      package = check-version packages "platforms" version;
    }
  ) platformVersions;

  sources = map (version:
    deployAndroidPackage {
      package = check-version packages "sources" version;
    }
  ) platformVersions;

  system-images = lib.flatten (map (apiVersion:
    map (type:
      # Deploy all system images with the same  systemImageType in one derivation to avoid the `null` problem below
      # with avdmanager when trying to create an avd!
      #
      # ```
      # $ yes "" | avdmanager create avd --force --name testAVD --package 'system-images;android-33;google_apis;x86_64'
      # Error: Package path is not valid. Valid system image paths are:
      # null
      # ```
      let
        availablePackages = map (abiVersion:
          system-images-packages.${apiVersion}.${type}.${abiVersion}
        ) (builtins.filter (abiVersion:
          lib.hasAttrByPath [apiVersion type abiVersion] system-images-packages
        ) abiVersions);

        instructions = builtins.listToAttrs (map (package: {
            name = package.name;
            value = lib.optionalString (lib.hasPrefix "google_apis" type) ''
              # Patch 'google_apis' system images so they're recognized by the sdk.
              # Without this, `android list targets` shows 'Tag/ABIs : no ABIs' instead
              # of 'Tag/ABIs : google_apis*/*' and the emulator fails with an ABI-related error.
              sed -i '/^Addon.Vendor/d' source.properties
            '';
          }) availablePackages
        );
      in
      lib.optionals (availablePackages != [])
        (deployAndroidPackages {
          packages = availablePackages;
          patchesInstructions = instructions;
        })
    ) systemImageTypes
  ) platformVersions);

  cmake = map (version:
    callPackage ./cmake.nix {
      inherit deployAndroidPackage os arch meta;
      package = check-version packages "cmake" version;
    }
  ) cmakeVersions;

  # Returns true if we should link the specified plugins.
  shouldLink = check: packages:
    assert builtins.isList packages;
    if check == true then
      true
    else if check == false then
      false
    else if check == null || check == "if-supported" then
      let
        hasSrc = package: package.src != null && (builtins.isList package.src -> builtins.length package.src > 0);
      in
      packages != [] && lib.all hasSrc packages
    else
      throw "Invalid argument ${toString check}; use true, false, or null/if-supported";

  # Creates a NDK bundle.
  makeNdkBundle = package:
    callPackage ./ndk-bundle {
      inherit deployAndroidPackage os arch platform-tools meta package;
    };

  # All NDK bundles.
  ndk-bundles = lib.flatten (
    map (version:
      let
        package = makeNdkBundle (packages.ndk-bundle.${ndkVersion} or packages.ndk.${ndkVersion});
      in
      lib.optional (shouldLink includeNDK [package]) package
    ) ndkVersions
  );

  # The "default" NDK bundle.
  ndk-bundle = if ndk-bundles == [] then null else lib.head ndk-bundles;

  # Makes a Google API bundle.
  google-apis = map (version:
    deployAndroidPackage {
      package = (check-version addons "addons" version).google_apis;
    }
  ) (builtins.filter (platformVersion: lib.versionOlder platformVersion "26") platformVersions); # API level 26 and higher include Google APIs by default

  google-tv-addons = map (version:
    deployAndroidPackage {
      package = (check-version addons "addons" version).google_tv_addon;
    }
  ) platformVersions;

  # Function that automatically links all plugins for which multiple versions can coexist
  linkPlugins = {name, plugins, check ? true}:
    lib.optionalString (shouldLink check plugins) ''
      mkdir -p ${name}
      ${lib.concatMapStrings (plugin: ''
        ln -s ${plugin}/libexec/android-sdk/${name}/* ${name}
      '') plugins}
    '';

  # Function that automatically links all NDK plugins.
  linkNdkPlugins = {name, plugins, rootName ? name, check ? true}:
    lib.optionalString (shouldLink check plugins) ''
      mkdir -p ${rootName}
      ${lib.concatMapStrings (plugin: ''
        ln -s ${plugin}/libexec/android-sdk/${name} ${rootName}/${plugin.version}
      '') plugins}
    '';

  # Function that automatically links the default NDK plugin.
  linkNdkPlugin = {name, plugin, check}:
    lib.optionalString (shouldLink check [plugin]) ''
      ln -s ${plugin}/libexec/android-sdk/${name} ${name}
    '';

  # Function that automatically links a plugin for which only one version exists
  linkPlugin = {name, plugin, check ? true}:
    lib.optionalString (shouldLink check [plugin]) ''
      ln -s ${plugin}/libexec/android-sdk/${name} ${name}
    '';

  linkSystemImages = { images, check }: lib.optionalString (shouldLink check images) ''
    mkdir -p system-images
    ${lib.concatMapStrings (system-image: ''
      apiVersion=$(basename $(echo ${system-image}/libexec/android-sdk/system-images/*))
      type=$(basename $(echo ${system-image}/libexec/android-sdk/system-images/*/*))
      mkdir -p system-images/$apiVersion
      ln -s ${system-image}/libexec/android-sdk/system-images/$apiVersion/$type system-images/$apiVersion/$type
    '') images}
  '';

  # Links all plugins related to a requested platform
  linkPlatformPlugins = {name, plugins, check}:
    lib.optionalString (shouldLink check plugins) ''
      mkdir -p ${name}
      ${lib.concatMapStrings (plugin: ''
        ln -s ${plugin}/libexec/android-sdk/${name}/* ${name}
      '') plugins}
    ''; # */

  cmdline-tools-package = check-version packages "cmdline-tools" cmdLineToolsVersion;

  # This derivation deploys the tools package and symlinks all the desired
  # plugins that we want to use. If the license isn't accepted, prints all the licenses
  # requested and throws.
  androidsdk = if !licenseAccepted then throw ''
    ${builtins.concatStringsSep "\n\n" (mkLicenseTexts licenseNames)}

    You must accept the following licenses:
    ${lib.concatMapStringsSep "\n" (str: "  - ${str}") licenseNames}

    a)
      by setting nixpkgs config option 'android_sdk.accept_license = true;'.
    b)
      by an environment variable for a single invocation of the nix tools.
        $ export NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE=1
  '' else callPackage ./cmdline-tools.nix {
    inherit deployAndroidPackage os arch meta;

    package = cmdline-tools-package;

    postInstall = ''
      # Symlink all requested plugins
      ${linkPlugin { name = "platform-tools"; plugin = platform-tools; }}
      ${linkPlugin { name = "tools"; plugin = tools; check = toolsVersion != null; }}
      ${linkPlugins { name = "build-tools"; plugins = build-tools; }}
      ${linkPlugin { name = "emulator"; plugin = emulator; check = includeEmulator; }}
      ${linkPlugins { name = "platforms"; plugins = platforms; }}
      ${linkPlatformPlugins { name = "sources"; plugins = sources; check = includeSources; }}
      ${linkPlugins { name = "cmake"; plugins = cmake; check = includeCmake; }}
      ${linkNdkPlugins { name = "ndk-bundle"; rootName = "ndk"; plugins = ndk-bundles; check = includeNDK; }}
      ${linkNdkPlugin { name = "ndk-bundle"; plugin = ndk-bundle; check = includeNDK; }}
      ${linkSystemImages { images = system-images; check = includeSystemImages; }}
      ${linkPlatformPlugins { name = "add-ons"; plugins = google-apis; check = useGoogleAPIs; }}
      ${linkPlatformPlugins { name = "add-ons"; plugins = google-tv-addons; check = useGoogleTVAddOns; }}

      # Link extras
      ${lib.concatMapStrings (identifier:
        let
          package = addons.extras.${identifier};
          path = package.path;
          extras = callPackage ./extras.nix {
            inherit deployAndroidPackage package os arch meta;
          };
        in
        ''
          targetDir=$(dirname ${path})
          mkdir -p $targetDir
          ln -s ${extras}/libexec/android-sdk/${path} $targetDir
        '') includeExtras}

      # Expose common executables in bin/
      mkdir -p $out/bin

      for i in ${platform-tools}/bin/*; do
          ln -s $i $out/bin
      done

      ${lib.optionalString (shouldLink includeEmulator [emulator]) ''
        for i in ${emulator}/bin/*; do
            ln -s $i $out/bin
        done
      ''}

      find $ANDROID_SDK_ROOT/${cmdline-tools-package.path}/bin -type f -executable | while read i; do
          ln -s $i $out/bin
      done

      # Write licenses
      mkdir -p licenses
      ${lib.concatMapStrings (licenseName:
        let
          licenseHashes = builtins.concatStringsSep "\n" (mkLicenseHashes licenseName);
          licenseHashFile = writeText "androidenv-${licenseName}" licenseHashes;
        in
        ''
          ln -s ${licenseHashFile} licenses/${licenseName}
        '') licenseNames}
    '';
  };
}
