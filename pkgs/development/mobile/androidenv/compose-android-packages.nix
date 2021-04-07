{ requireFile, autoPatchelfHook, pkgs, pkgsHostHost, pkgs_i686
, licenseAccepted ? false
}:

{ toolsVersion ? "26.1.1"
, platformToolsVersion ? "30.0.5"
, buildToolsVersions ? [ "30.0.3" ]
, includeEmulator ? false
, emulatorVersion ? "30.3.4"
, platformVersions ? []
, includeSources ? false
, includeSystemImages ? false
, systemImageTypes ? [ "google_apis_playstore" ]
, abiVersions ? [ "armeabi-v7a" ]
, cmakeVersions ? [ ]
, includeNDK ? false
, ndkVersion ? "22.0.7026061"
, useGoogleAPIs ? false
, useGoogleTVAddOns ? false
, includeExtras ? []
, repoJson ? ./repo.json
, repoXmls ? null
, extraLicenses ? []
}:

let
  inherit (pkgs) stdenv lib fetchurl;
  inherit (pkgs.buildPackages) makeWrapper unzip;

  # Determine the Android os identifier from Nix's system identifier
  os = if stdenv.system == "x86_64-linux" then "linux"
    else if stdenv.system == "x86_64-darwin" then "macosx"
    else throw "No Android SDK tarballs are available for system architecture: ${stdenv.system}";

  # Uses mkrepo.rb to create a repo spec.
  mkRepoJson = { packages ? [], images ? [], addons ? [] }: let
    mkRepoRuby = (pkgs.ruby.withPackages (pkgs: with pkgs; [ slop nokogiri ]));
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
           builtins.fromJSON (builtins.readFile "${mkRepoJson repoXmlSpec}")
         else
           builtins.fromJSON (builtins.readFile repoJson);

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
  deployAndroidPackage = import ./deploy-androidpackage.nix {
    inherit stdenv unzip;
  };

  platform-tools = import ./platform-tools.nix {
    inherit deployAndroidPackage os autoPatchelfHook pkgs lib;
    package = packages.platform-tools.${platformToolsVersion};
  };

  build-tools = map (version:
    import ./build-tools.nix {
      inherit deployAndroidPackage os autoPatchelfHook makeWrapper pkgs pkgs_i686 lib;
      package = packages.build-tools.${version};
    }
  ) buildToolsVersions;

  emulator = import ./emulator.nix {
    inherit deployAndroidPackage os autoPatchelfHook makeWrapper pkgs pkgs_i686 lib;
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
    import ./cmake.nix {
      inherit deployAndroidPackage os autoPatchelfHook pkgs lib;
      package = packages.cmake.${version};
    }
  ) cmakeVersions;

  ndk-bundle = import ./ndk-bundle {
    inherit deployAndroidPackage os autoPatchelfHook makeWrapper pkgs pkgsHostHost lib platform-tools;
    package = packages.ndk-bundle.${ndkVersion};
  };

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
  '' else import ./tools.nix {
    inherit deployAndroidPackage requireFile packages toolsVersion autoPatchelfHook makeWrapper os pkgs pkgs_i686 lib;

    postInstall = ''
      # Symlink all requested plugins

      ${linkPlugin { name = "platform-tools"; plugin = platform-tools; }}
      ${linkPlugins { name = "build-tools"; plugins = build-tools; }}
      ${linkPlugin { name = "emulator"; plugin = emulator; check = includeEmulator; }}
      ${linkPlugins { name = "platforms"; plugins = platforms; }}
      ${linkPlatformPlugins { name = "sources"; plugins = sources; check = includeSources; }}
      ${linkPlugins { name = "cmake"; plugins = cmake; }}
      ${linkPlugin { name = "ndk-bundle"; plugin = ndk-bundle; check = includeNDK; }}

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

      # Write licenses
      mkdir -p licenses
      ${lib.concatMapStrings (licenseName:
        let
          licenseHashes = builtins.concatStringsSep "\n" (mkLicenseHashes licenseName);
          licenseHashFile = pkgs.writeText "androidenv-${licenseName}" licenseHashes;
        in
        ''
          ln -s ${licenseHashFile} licenses/${licenseName}
        '') licenseNames}
    '';
  };
}
