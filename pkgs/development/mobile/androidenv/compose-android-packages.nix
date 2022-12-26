{ callPackage, stdenv, lib, fetchurl, ruby, writeText
, licenseAccepted ? false
}:

{ toolsVersion ? "26.1.1"
, platformToolsVersion ? "33.0.3"
, buildToolsVersions ? [ "33.0.1" ]
, includeEmulator ? false
, emulatorVersion ? "31.3.14"
, platformVersions ? []
, includeSources ? false
, includeSystemImages ? false
, systemImageTypes ? [ "google_apis_playstore" ]
, abiVersions ? [ "armeabi-v7a" "arm64-v8a" ]
, cmakeVersions ? [ ]
, includeNDK ? false
, ndkVersion ? "25.1.8937393"
, ndkVersions ? [ndkVersion]
, useGoogleAPIs ? false
, useGoogleTVAddOns ? false
, includeExtras ? []
, repoJson ? ./repo.json
, repoXmls ? null
, extraLicenses ? []
}:

let
  # Determine the Android os identifier from Nix's system identifier
  os = if stdenv.system == "x86_64-linux" then "linux"
    else if stdenv.system == "x86_64-darwin" then "macosx"
    else throw "No Android SDK tarballs are available for system architecture: ${stdenv.system}";

  # Uses mkrepo.rb to create a repo spec.
  mkRepoJson = { packages ? [], images ? [], addons ? [] }: let
    mkRepoRuby = (ruby.withPackages (pkgs: with pkgs; [ slop nokogiri ]));
    mkRepoRubyArguments = lib.lists.flatten [
      (builtins.map (package: ["--packages" "${package}"]) packages)
      (builtins.map (image: ["--images" "${image}"]) images)
      (builtins.map (addon: ["--addons" "${addon}"]) addons)
    ];
  in
  stdenv.mkDerivation {
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

  # Reads the repo JSON. If repoXmls is provided, will build a repo JSON into the Nix store.
  repo = if repoXmls != null then
           let
             repoXmlSpec = {
               packages = repoXmls.packages or [];
               images = repoXmls.images or [];
               addons = repoXmls.addons or [];
             };
           in
           lib.importJSON "${mkRepoJson repoXmlSpec}"
         else
           lib.importJSON repoJson;

  # Converts all 'archives' keys in a repo spec to fetchurl calls.
  fetchArchives = attrSet:
    lib.attrsets.mapAttrsRecursive
      (path: value:
        if (builtins.elemAt path ((builtins.length path) - 1)) == "archives" then
          (builtins.listToAttrs
            (builtins.map
              (archive: lib.attrsets.nameValuePair archive.os (fetchurl { inherit (archive) url sha1; })) value))
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
rec {
  deployAndroidPackages = callPackage ./deploy-androidpackages.nix {
    inherit stdenv lib mkLicenses;
  };
  deployAndroidPackage = ({package, os ? null, buildInputs ? [], patchInstructions ? "", meta ? {}, ...}@args:
    let
      extraParams = removeAttrs args [ "package" "os" "buildInputs" "patchInstructions" ];
    in
    deployAndroidPackages ({
      inherit os buildInputs meta;
      packages = [ package ];
      patchesInstructions = { "${package.name}" = patchInstructions; };
    } // extraParams
  ));

  platform-tools = callPackage ./platform-tools.nix {
    inherit deployAndroidPackage;
    os = if stdenv.system == "aarch64-darwin" then "macosx" else os; # "macosx" is a universal binary here
    package = packages.platform-tools.${platformToolsVersion};
  };

  build-tools = map (version:
    callPackage ./build-tools.nix {
      inherit deployAndroidPackage os;
      package = packages.build-tools.${version};
    }
  ) buildToolsVersions;

  emulator = callPackage ./emulator.nix {
    inherit deployAndroidPackage os;
    package = packages.emulator.${emulatorVersion};
  };

  platforms = map (version:
    deployAndroidPackage {
      inherit os;
      package = packages.platforms.${version};
    }
  ) platformVersions;

  sources = map (version:
    deployAndroidPackage {
      inherit os;
      package = packages.sources.${version};
    }
  ) platformVersions;

  system-images = lib.flatten (map (apiVersion:
    map (type:
      map (abiVersion:
        if lib.hasAttrByPath [apiVersion type abiVersion] system-images-packages then
          deployAndroidPackage {
            inherit os;
            package = system-images-packages.${apiVersion}.${type}.${abiVersion};
            # Patch 'google_apis' system images so they're recognized by the sdk.
            # Without this, `android list targets` shows 'Tag/ABIs : no ABIs' instead
            # of 'Tag/ABIs : google_apis*/*' and the emulator fails with an ABI-related error.
            patchInstructions = lib.optionalString (lib.hasPrefix "google_apis" type) ''
              sed -i '/^Addon.Vendor/d' source.properties
            '';
          }
        else []
      ) abiVersions
    ) systemImageTypes
  ) platformVersions);

  cmake = map (version:
    callPackage ./cmake.nix {
      inherit deployAndroidPackage os;
      package = packages.cmake.${version};
    }
  ) cmakeVersions;

  # Creates a NDK bundle.
  makeNdkBundle = ndkVersion:
    callPackage ./ndk-bundle {
      inherit deployAndroidPackage os platform-tools;
      package = packages.ndk-bundle.${ndkVersion} or packages.ndk.${ndkVersion};
    };

  # All NDK bundles.
  ndk-bundles = if includeNDK then map makeNdkBundle ndkVersions else [];

  # The "default" NDK bundle.
  ndk-bundle = if includeNDK then lib.findFirst (x: x != null) null ndk-bundles else null;

  google-apis = map (version:
    deployAndroidPackage {
      inherit os;
      package = addons.addons.${version}.google_apis;
    }
  ) (builtins.filter (platformVersion: platformVersion < "26") platformVersions); # API level 26 and higher include Google APIs by default

  google-tv-addons = map (version:
    deployAndroidPackage {
      inherit os;
      package = addons.addons.${version}.google_tv_addon;
    }
  ) platformVersions;

  # Function that automatically links all plugins for which multiple versions can coexist
  linkPlugins = {name, plugins}:
    lib.optionalString (plugins != []) ''
      mkdir -p ${name}
      ${lib.concatMapStrings (plugin: ''
        ln -s ${plugin}/libexec/android-sdk/${name}/* ${name}
      '') plugins}
    '';

  # Function that automatically links all NDK plugins.
  linkNdkPlugins = {name, plugins, rootName ? name}:
    lib.optionalString (plugins != []) ''
      mkdir -p ${rootName}
      ${lib.concatMapStrings (plugin: ''
        ln -s ${plugin}/libexec/android-sdk/${name} ${rootName}/${plugin.version}
      '') plugins}
    '';

  # Function that automatically links the default NDK plugin.
  linkNdkPlugin = {name, plugin, check}:
    lib.optionalString check ''
      ln -s ${plugin}/libexec/android-sdk/${name} ${name}
    '';

  # Function that automatically links a plugin for which only one version exists
  linkPlugin = {name, plugin, check ? true}:
    lib.optionalString check ''
      ln -s ${plugin}/libexec/android-sdk/* ${name}
    '';

  # Links all plugins related to a requested platform
  linkPlatformPlugins = {name, plugins, check}:
    lib.optionalString check ''
      mkdir -p ${name}
      ${lib.concatMapStrings (plugin: ''
        ln -s ${plugin}/libexec/android-sdk/${name}/* ${name}
      '') plugins}
    ''; # */

  # This derivation deploys the tools package and symlinks all the desired
  # plugins that we want to use. If the license isn't accepted, prints all the licenses
  # requested and throws.
  androidsdk = if !licenseAccepted then throw ''
    ${builtins.concatStringsSep "\n\n" (mkLicenseTexts licenseNames)}

    You must accept the following licenses:
    ${lib.concatMapStringsSep "\n" (str: "  - ${str}") licenseNames}

    by setting nixpkgs config option 'android_sdk.accept_license = true;'.
  '' else callPackage ./tools.nix {
    inherit deployAndroidPackage packages toolsVersion os;

    postInstall = ''
      # Symlink all requested plugins
      ${linkPlugin { name = "platform-tools"; plugin = platform-tools; }}
      ${linkPlugins { name = "build-tools"; plugins = build-tools; }}
      ${linkPlugin { name = "emulator"; plugin = emulator; check = includeEmulator; }}
      ${linkPlugins { name = "platforms"; plugins = platforms; }}
      ${linkPlatformPlugins { name = "sources"; plugins = sources; check = includeSources; }}
      ${linkPlugins { name = "cmake"; plugins = cmake; }}
      ${linkNdkPlugins { name = "ndk-bundle"; rootName = "ndk"; plugins = ndk-bundles; }}
      ${linkNdkPlugin { name = "ndk-bundle"; plugin = ndk-bundle; check = includeNDK; }}

      ${lib.optionalString includeSystemImages ''
        mkdir -p system-images
        ${lib.concatMapStrings (system-image: ''
          apiVersion=$(basename $(echo ${system-image}/libexec/android-sdk/system-images/*))
          type=$(basename $(echo ${system-image}/libexec/android-sdk/system-images/*/*))
          mkdir -p system-images/$apiVersion/$type
          ln -s ${system-image}/libexec/android-sdk/system-images/$apiVersion/$type/* system-images/$apiVersion/$type
        '') system-images}
      ''}

      ${linkPlatformPlugins { name = "add-ons"; plugins = google-apis; check = useGoogleAPIs; }}
      ${linkPlatformPlugins { name = "add-ons"; plugins = google-apis; check = useGoogleTVAddOns; }}

      # Link extras
      ${lib.concatMapStrings (identifier:
        let
          path = addons.extras.${identifier}.path;
          addon = deployAndroidPackage {
            inherit os;
            package = addons.extras.${identifier};
          };
        in
        ''
          targetDir=$(dirname ${path})
          mkdir -p $targetDir
          ln -s ${addon}/libexec/android-sdk/${path} $targetDir
        '') includeExtras}

      # Expose common executables in bin/
      mkdir -p $out/bin
      find $PWD/tools -not -path '*/\.*' -type f -executable -mindepth 1 -maxdepth 1 | while read i
      do
          ln -s $i $out/bin
      done

      find $PWD/tools/bin -not -path '*/\.*' -type f -executable -mindepth 1 -maxdepth 1 | while read i
      do
          ln -s $i $out/bin
      done

      for i in ${platform-tools}/bin/*
      do
          ln -s $i $out/bin
      done

      # the emulator auto-linked from platform-tools does not find its local qemu, while this one does
      ${lib.optionalString includeEmulator ''
        rm $out/bin/emulator
        ln -s $out/libexec/android-sdk/emulator/emulator $out/bin
      ''}

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
