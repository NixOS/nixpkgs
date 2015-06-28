{pkgs, pkgs_i686}:

rec {
  platformTools = import ./platform-tools.nix {
    inherit (pkgs) stdenv fetchurl unzip;
    stdenv_32bit = pkgs_i686.stdenv;
  };
  
  buildTools = import ./build-tools.nix {
    inherit (pkgs) stdenv fetchurl unzip;
    stdenv_32bit = pkgs_i686.stdenv;
    zlib_32bit = pkgs_i686.zlib;
  };
  
  support = import ./support.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };
  
  supportRepository = import ./support-repository.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  platforms = if (pkgs.stdenv.system == "i686-linux" || pkgs.stdenv.system == "x86_64-linux")
    then import ./platforms-linux.nix {
      inherit (pkgs) stdenv fetchurl unzip;
    }
    else if pkgs.stdenv.system == "x86_64-darwin"
    then import ./platforms-macosx.nix {
      inherit (pkgs) stdenv fetchurl unzip;
    }
    else throw "Platform: ${pkgs.stdenv.system} not supported!";

  sysimages = import ./sysimages.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  addons = import ./addons.nix {
    inherit (pkgs) stdenv fetchurl unzip;
  };

  androidsdk = import ./androidsdk.nix {
    inherit (pkgs) stdenv fetchurl unzip makeWrapper;
    inherit (pkgs) freetype fontconfig glib gtk atk mesa file alsaLib jdk coreutils;
    inherit (pkgs.xorg) libX11 libXext libXrender libxcb libXau libXdmcp libXtst;
    
    inherit platformTools buildTools support supportRepository platforms sysimages addons;
    
    stdenv_32bit = pkgs_i686.stdenv;
    zlib_32bit = pkgs_i686.zlib;
    libX11_32bit = pkgs_i686.xorg.libX11;
    libxcb_32bit = pkgs_i686.xorg.libxcb;
    libXau_32bit = pkgs_i686.xorg.libXau;
    libXdmcp_32bit = pkgs_i686.xorg.libXdmcp;
    libXext_32bit = pkgs_i686.xorg.libXext;
    mesa_32bit = pkgs_i686.mesa;
    alsaLib_32bit = pkgs_i686.alsaLib;
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

  androidndk = import ./androidndk.nix {
    inherit (pkgs) stdenv fetchurl zlib ncurses p7zip lib makeWrapper;
    inherit (pkgs) coreutils file findutils gawk gnugrep gnused jdk which;
    inherit platformTools;
  };

  androidndk_r8e = import ./androidndk_r8e.nix {
    inherit (pkgs) stdenv fetchurl zlib ncurses lib makeWrapper;
    inherit (pkgs) coreutils file findutils gawk gnugrep gnused jdk which;
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
}
