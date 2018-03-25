{ buildPackages, pkgs, pkgs_i686, targetPackages
, includeSources ? true
}:

rec {
  platformTools = import ./platform-tools.nix {
    inherit buildPackages pkgs;
  };

  support = import ./support.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  supportRepository = addons.android_m2repository;

  platforms = if (pkgs.stdenv.system == "i686-linux" || pkgs.stdenv.system == "x86_64-linux")
    then import ./platforms-linux.nix {
      inherit (pkgs) stdenv fetchurl unzip;
    }
    else if pkgs.stdenv.system == "x86_64-darwin"
    then import ./platforms-macosx.nix {
      inherit (pkgs) stdenv fetchurl unzip;
    }
    else throw "Platform: ${pkgs.stdenv.system} not supported!";

  buildTools_all = let bt = if (pkgs.stdenv.system == "i686-linux" || pkgs.stdenv.system == "x86_64-linux")
    then import ./build-tools-linux.nix {
        inherit (pkgs) stdenv fetchurl unzip zlib file;
        stdenv_32bit = pkgs_i686.stdenv;
        zlib_32bit = pkgs_i686.zlib;
        ncurses_32bit = pkgs_i686.ncurses5;
        ncurses = pkgs.ncurses5;
    }
    else if pkgs.stdenv.system == "x86_64-darwin"
    then import ./platforms-macosx.nix {
      inherit (pkgs) stdenv fetchurl unzip zlib file;
      stdenv_32bit = pkgs_i686.stdenv;
      zlib_32bit = pkgs_i686.zlib;
      ncurses_32bit = pkgs_i686.ncurses5;
      ncurses = pkgs.ncurses5;
    }
    else throw "Platform: ${pkgs.stdenv.system} not supported!";
      in bt // { buildTools_latest = bt.buildTools_26_0_1; };
  buildTools = buildTools_all.buildTools_latest;

  sysimages = import ./sysimages.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  addons = import ./addons.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  sources = import ./sources.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  androidsdk = import ./androidsdk.nix {
    inherit (pkgs) stdenv fetchurl unzip makeWrapper;
    inherit (pkgs) zlib glxinfo freetype fontconfig glib gtk2 atk libGLU_combined file alsaLib jdk coreutils libpulseaudio dbus;
    inherit (pkgs.xorg) libX11 libXext libXrender libxcb libXau libXdmcp libXtst xkeyboardconfig;

    inherit platformTools support platforms sysimages addons sources includeSources;
    buildTools = buildTools_all;

    stdenv_32bit = pkgs_i686.stdenv;
  };

  androidsdk_2_1 = androidsdk {
    platformVersions = [ "7" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_2_2 = androidsdk {
    platformVersions = [ "8" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_2_3_3 = androidsdk {
    platformVersions = [ "10" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_3_0 = androidsdk {
    platformVersions = [ "11" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_3_1 = androidsdk {
    platformVersions = [ "12" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_3_2 = androidsdk {
    platformVersions = [ "13" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_4_0 = androidsdk {
    platformVersions = [ "14" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_4_0_3 = androidsdk {
    platformVersions = [ "15" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_4_1 = androidsdk {
    platformVersions = [ "16" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_4_2 = androidsdk {
    platformVersions = [ "17" ];
    buildToolsVersions = [ "17" ];
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_4_3 = androidsdk {
    platformVersions = [ "18" ];
    buildToolsVersions = [ "18_1_1" ];
    abiVersions = [ "armeabi-v7a" "x86" ];
    useGoogleAPIs = true;
  };

  androidsdk_4_4 = androidsdk {
    platformVersions = [ "19" ];
    buildToolsVersions = [ "19_1" ];
    abiVersions = [ "armeabi-v7a" "x86" ];
    useGoogleAPIs = true;
  };

  androidsdk_5_0_1 = androidsdk {
    platformVersions = [ "21" ];
    buildToolsVersions = [ "21_1_2" ];
    abiVersions = [ "armeabi-v7a" "x86" ];
    useGoogleAPIs = true;
  };

  androidsdk_5_0_1_extras = androidsdk {
    platformVersions = [ "21" ];
    buildToolsVersions = [ "21_1_2" ];
    abiVersions = [ "armeabi-v7a" "x86" ];
    useGoogleAPIs = true;
    useGoogleRepo = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
  };

  androidsdk_5_1_1 = androidsdk {
    platformVersions = [ "22" ];
    buildToolsVersions = [ "22_0_1" ];
    abiVersions = [ "armeabi-v7a" "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_5_1_1_extras = androidsdk {
    platformVersions = [ "22" ];
    buildToolsVersions = [ "22_0_1" ];
    abiVersions = [ "armeabi-v7a" "x86" "x86_64"];
    useGoogleAPIs = true;
    useGoogleRepo = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
  };

  androidsdk_6_0 = androidsdk {
    platformVersions = [ "23" ];
    buildToolsVersions = [ "23_0_3" ];
    abiVersions = [ "armeabi-v7a" "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_6_0_extras = androidsdk {
    platformVersions = [ "23" ];
    buildToolsVersions = [ "23_0_3" ];
    abiVersions = [ "armeabi-v7a" "x86" "x86_64"];
    useGoogleAPIs = true;
    useGoogleRepo = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
    useInstantApps = true;
  };

  androidsdk_7_0 = androidsdk {
    platformVersions = [ "24" ];
    buildToolsVersions = [ "24_0_3" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_7_0_extras = androidsdk {
    platformVersions = [ "24" ];
    buildToolsVersions = [ "24_0_3" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
    useGoogleRepo = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
    useInstantApps = true;
  };

  androidsdk_7_1_1 = androidsdk {
    platformVersions = [ "25" ];
    buildToolsVersions = [ "25_0_3" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_7_1_1_extras = androidsdk {
    platformVersions = [ "25" ];
    buildToolsVersions = [ "25_0_3" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
    useGoogleRepo = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
    useInstantApps = true;
  };

  androidsdk_8_0 = androidsdk {
    platformVersions = [ "26" ];
    buildToolsVersions = [ "26_0_1" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_8_0_extras = androidsdk {
    platformVersions = [ "26" ];
    buildToolsVersions = [ "26_0_1" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
    useGoogleRepo = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
    useInstantApps = true;
  };

  androidndk = import ./androidndk.nix {
    inherit (buildPackages)
      p7zip makeWrapper;
    inherit (pkgs)
      stdenv fetchurl zlib ncurses lib
      coreutils file findutils gawk gnugrep gnused jdk which;
    inherit platformTools;
  };

  androidndk_r8e = import ./androidndk_r8e.nix {
    inherit (buildPackages)
      makeWrapper;
    inherit (pkgs)
      stdenv fetchurl zlib ncurses lib
      coreutils file findutils gawk gnugrep gnused jdk which;
    inherit platformTools;
  };

  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv jdk ant gnumake gawk file which;
    inherit androidsdk androidndk;
  };

  emulateApp = import ./emulate-app.nix {
    inherit (pkgs) stdenv;
    inherit androidsdk;
  };

  androidndkPkgs = import ./androidndk-pkgs.nix {
    inherit (buildPackages)
      makeWrapper;
    inherit (pkgs)
      lib hostPlatform targetPlatform
      runCommand wrapBintoolsWith wrapCCWith;
    # buildPackages.foo rather than buildPackages.buildPackages.foo would work,
    # but for splicing messing up on infinite recursion for the variants we
    # *dont't* use. Using this workaround, but also making a test to ensure
    # these two really are the same.
    buildAndroidndk = buildPackages.buildPackages.androidenv.androidndk;
    inherit androidndk;
    targetAndroidndkPkgs = targetPackages.androidenv.androidndkPkgs;
  };
}
