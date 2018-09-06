{ buildPackages, pkgs, pkgs_i686, targetPackages
, includeSources ? true
}:

# TODO: use callPackage instead of import to avoid so many inherits

rec {
  platformTools = import ./platform-tools.nix {
    inherit buildPackages pkgs;
  };

  buildTools = import ./build-tools.nix {
    inherit (pkgs) stdenv fetchurl unzip zlib file;
    stdenv_32bit = pkgs_i686.stdenv;
    zlib_32bit = pkgs_i686.zlib;
    ncurses_32bit = pkgs_i686.ncurses5;
    ncurses = pkgs.ncurses5;
  };

  support = import ./support.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  supportRepository = import ./support-repository.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  platforms = if (pkgs.stdenv.hostPlatform.system == "i686-linux" || pkgs.stdenv.hostPlatform.system == "x86_64-linux")
    then import ./platforms-linux.nix {
      inherit (pkgs) stdenv fetchurl unzip;
    }
    else if pkgs.stdenv.hostPlatform.system == "x86_64-darwin"
    then import ./platforms-macosx.nix {
      inherit (pkgs) stdenv fetchurl unzip;
    }
    else throw "Platform: ${pkgs.stdenv.hostPlatform.system} not supported!";

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
    inherit (pkgs) stdenv fetchurl unzip makeWrapper zlib
                   glxinfo freetype fontconfig glib gtk2 atk
                   libGLU_combined file alsaLib jdk coreutils
                   libpulseaudio dbus fetchzip;
    inherit (pkgs.xorg) libX11 libXext libXrender
                        libxcb libXau libXdmcp libXtst xkeyboardconfig;

    inherit platformTools buildTools support
            supportRepository platforms sysimages
            addons sources includeSources;

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
    abiVersions = [ "armeabi-v7a" ];
    useGoogleAPIs = true;
  };

  androidsdk_4_3 = androidsdk {
    platformVersions = [ "18" ];
    abiVersions = [ "armeabi-v7a" "x86" ];
    useGoogleAPIs = true;
  };

  androidsdk_4_4 = androidsdk {
    platformVersions = [ "19" ];
    abiVersions = [ "armeabi-v7a" "x86" ];
    useGoogleAPIs = true;
  };

  androidsdk_5_0_1 = androidsdk {
    platformVersions = [ "21" ];
    abiVersions = [ "armeabi-v7a" "x86" ];
    useGoogleAPIs = true;
  };

  androidsdk_5_0_1_extras = androidsdk {
    platformVersions = [ "21" ];
    abiVersions = [ "armeabi-v7a" "x86" ];
    useGoogleAPIs = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
  };

  androidsdk_5_1_1 = androidsdk {
    platformVersions = [ "22" ];
    abiVersions = [ "armeabi-v7a" "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_5_1_1_extras = androidsdk {
    platformVersions = [ "22" ];
    abiVersions = [ "armeabi-v7a" "x86" "x86_64"];
    useGoogleAPIs = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
  };

  androidsdk_6_0 = androidsdk {
    platformVersions = [ "23" ];
    abiVersions = [ "armeabi-v7a" "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_6_0_extras = androidsdk {
    platformVersions = [ "23" ];
    abiVersions = [ "armeabi-v7a" "x86" "x86_64"];
    useGoogleAPIs = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
    useInstantApps = true;
  };

  androidsdk_7_0 = androidsdk {
    platformVersions = [ "24" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_7_0_extras = androidsdk {
    platformVersions = [ "24" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
    useInstantApps = true;
  };

  androidsdk_7_1_1 = androidsdk {
    platformVersions = [ "25" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_7_1_1_extras = androidsdk {
    platformVersions = [ "25" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
    useInstantApps = true;
  };

  androidsdk_8_0 = androidsdk {
    platformVersions = [ "26" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
  };

  androidsdk_8_0_extras = androidsdk {
    platformVersions = [ "26" ];
    abiVersions = [ "x86" "x86_64"];
    useGoogleAPIs = true;
    useExtraSupportLibs = true;
    useGooglePlayServices = true;
    useInstantApps = true;
  };

  androidsdk_latest = androidsdk_8_0;

  androidndk_10e = pkgs.callPackage ./androidndk.nix {
    inherit (buildPackages)
      unzip makeWrapper;
    inherit (pkgs)
      stdenv fetchurl zlib ncurses5 lib python3 libcxx
      coreutils file findutils gawk gnugrep gnused jdk which;
    inherit platformTools;
    version = "10e";
    sha256 = "032j3sgk93bjbkny84i17ph61dhjmsax9ddqng1zbi2p7dgl0pzf";
  };

  androidndk_16b = pkgs.callPackage ./androidndk.nix {
    inherit (buildPackages)
       unzip makeWrapper;
    inherit (pkgs)
      stdenv fetchurl zlib ncurses5 lib python3 libcxx
      coreutils file findutils gawk gnugrep gnused jdk which;
    inherit platformTools;
    version = "16b";
    sha256 = "00frcnvpcsngv00p6l2vxj4cwi2mwcm9lnjvm3zv4wrp6pss9pmw";
  };

  androidndk_17 = pkgs.callPackage ./androidndk.nix {
    inherit (buildPackages)
      unzip makeWrapper;
    inherit (pkgs)
      stdenv fetchurl zlib ncurses5 lib python3 libcxx
      coreutils file findutils gawk gnugrep gnused jdk which;
    inherit platformTools;
    version = "17";
    sha256 = "1jj3zy958zsidywqd5nwdyrnr72rf9zhippkl8rbqxfy8wxq2gds";
  };
  androidndk = androidndk_17;

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

  androidndkPkgs_17 = import ./androidndk-pkgs.nix {
    inherit (buildPackages)
      makeWrapper;
    inherit (pkgs)
      lib stdenv
      runCommand wrapBintoolsWith wrapCCWith;
    # buildPackages.foo rather than buildPackages.buildPackages.foo would work,
    # but for splicing messing up on infinite recursion for the variants we
    # *dont't* use. Using this workaround, but also making a test to ensure
    # these two really are the same.
    buildAndroidndk = buildPackages.buildPackages.androidenv.androidndk_17;
    androidndk = androidndk_17;
    targetAndroidndkPkgs = targetPackages.androidenv.androidndkPkgs_17;
  };
  androidndkPkgs = androidndkPkgs_17;

  androidndkPkgs_10e = import ./androidndk-pkgs.nix {
    inherit (buildPackages)
      makeWrapper;
    inherit (pkgs)
      lib stdenv
      runCommand wrapBintoolsWith wrapCCWith;
    # buildPackages.foo rather than buildPackages.buildPackages.foo would work,
    # but for splicing messing up on infinite recursion for the variants we
    # *dont't* use. Using this workaround, but also making a test to ensure
    # these two really are the same.
    buildAndroidndk = buildPackages.buildPackages.androidenv.androidndk_10e;
    androidndk = androidndk_10e;
    targetAndroidndkPkgs = targetPackages.androidenv.androidndkPkgs_10e;
  };

  buildGradleApp = import ./build-gradle-app.nix {
    inherit (pkgs) stdenv jdk gnumake gawk file runCommand
                   which gradle fetchurl buildEnv;
    inherit androidsdk androidndk;
  };
}
