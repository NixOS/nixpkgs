{requireFile, autoPatchelfHook, pkgs, pkgs_i686, licenseAccepted ? false}:

{ toolsVersion ? "25.2.5"
, platformToolsVersion ? "29.0.6"
, buildToolsVersions ? [ "28.0.3" ]
, includeEmulator ? false
, emulatorVersion ? "30.0.3"
, platformVersions ? []
, includeSources ? false
, includeDocs ? false
, includeSystemImages ? false
, systemImageTypes ? [ "default" ]
, abiVersions ? [ "armeabi-v7a" ]
, lldbVersions ? [ ]
, cmakeVersions ? [ ]
, includeNDK ? false
, ndkVersion ? "18.1.5063045"
, useGoogleAPIs ? false
, useGoogleTVAddOns ? false
, includeExtras ? []
}:

let
  inherit (pkgs) stdenv lib fetchurl makeWrapper unzip;

  # Determine the Android os identifier from Nix's system identifier
  os = if stdenv.system == "x86_64-linux" then "linux"
    else if stdenv.system == "x86_64-darwin" then "macosx"
    else throw "No Android SDK tarballs are available for system architecture: ${stdenv.system}";

  # Generated Nix packages
  packages = import ./generated/packages.nix {
    inherit fetchurl;
  };

  # Generated system images
  system-images-packages-android = import ./generated/system-images-android.nix {
    inherit fetchurl;
  };

  system-images-packages-android-tv = import ./generated/system-images-android-tv.nix {
    inherit fetchurl;
  };

  system-images-packages-android-wear = import ./generated/system-images-android-wear.nix {
    inherit fetchurl;
  };

  system-images-packages-android-wear-cn = import ./generated/system-images-android-wear-cn.nix {
    inherit fetchurl;
  };

  system-images-packages-google_apis = import ./generated/system-images-google_apis.nix {
    inherit fetchurl;
  };

  system-images-packages-google_apis_playstore = import ./generated/system-images-google_apis_playstore.nix {
    inherit fetchurl;
  };

  system-images-packages =
    lib.recursiveUpdate
      system-images-packages-android
      (lib.recursiveUpdate system-images-packages-android-tv
        (lib.recursiveUpdate system-images-packages-android-wear
          (lib.recursiveUpdate system-images-packages-android-wear-cn
            (lib.recursiveUpdate system-images-packages-google_apis system-images-packages-google_apis_playstore))));

  # Generated addons
  addons = import ./generated/addons.nix {
    inherit fetchurl;
  };
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

  docs = deployAndroidPackage {
    inherit os;
    package = packages.docs."1";
  };

  emulator = import ./emulator.nix {
    inherit deployAndroidPackage os autoPatchelfHook makeWrapper pkgs pkgs_i686 lib;
    package = packages.emulator.${emulatorVersion}.${os};
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
      ) abiVersions
    ) systemImageTypes
  ) platformVersions);

  lldb = map (version:
    import ./lldb.nix {
      inherit deployAndroidPackage os autoPatchelfHook pkgs lib;
      package = packages.lldb.${version};
    }
  ) lldbVersions;

  cmake = map (version:
    import ./cmake.nix {
      inherit deployAndroidPackage os autoPatchelfHook pkgs lib;
      package = packages.cmake.${version};
    }
  ) cmakeVersions;

  ndk-bundle = import ./ndk-bundle {
    inherit deployAndroidPackage os autoPatchelfHook makeWrapper pkgs lib platform-tools;
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
  # plugins that we want to use.

  androidsdk = if !licenseAccepted then throw ''
    You must accept the Android Software Development Kit License Agreement at
    https://developer.android.com/studio/terms
    by setting nixpkgs config option 'android_sdk.accept_license = true;'
  '' else import ./tools.nix {
    inherit deployAndroidPackage requireFile packages toolsVersion autoPatchelfHook makeWrapper os pkgs pkgs_i686 lib;

    postInstall = ''
      # Symlink all requested plugins

      ${linkPlugin { name = "platform-tools"; plugin = platform-tools; }}
      ${linkPlugins { name = "build-tools"; plugins = build-tools; }}
      ${linkPlugin { name = "emulator"; plugin = emulator; check = includeEmulator; }}
      ${linkPlugin { name = "docs"; plugin = docs; check = includeDocs; }}
      ${linkPlugins { name = "platforms"; plugins = platforms; }}
      ${linkPlatformPlugins { name = "sources"; plugins = sources; check = includeSources; }}
      ${linkPlugins { name = "lldb"; plugins = lldb; }}
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
    '';
  };
}
