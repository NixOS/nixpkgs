{ stdenv, lib, fetchurl, patchelf, makeWrapper, writeShellApplication, makeDesktopItem, gtk3, glib, xorg, remarkable2-toolchain }:

stdenv.mkDerivation rec {
  name = "WarThunder";
  pname = "War-Thunder";
  version = "086d99e";

  src = fetchurl {
    url = "https://github.com/Mephist0phel3s/War-Thunder/archive/refs/tags/086d99e.tar.gz";
    hash = "sha256-vqpx85ZT1AzKk7dkZvMDMJf9GWalDM/F2JhaiMybMoY=";
  };

#### TODO acesx86_64, re-write shell wrapper
####      GOAL: Shell wrapper needs to sym link all files in store path to the out path in users home directory, then run the launcher with NO arguments.
  acesx86_64 = writeShellApplication rec {
  name = "acesx86_64";
  text = ''
    #!/bin/bash
    export ACES64_DIR="\$HOME/.aces64"
    STORE_PATH=\$(cat "\$HOME/.store_path.txt")

    '';};


  sourceRoot = "./${pname}-${version}";
  unpackPhase = false;
  dontConfigure = true;
  dontBuild = true;

  patchPhase = let
    pkgs = import <nixpkgs> {};
    libPath = lib.makeLibraryPath [ stdenv.cc.cc stdenv.cc.cc.lib remarkable2-toolchain glib gtk3 xorg.libX11 xorg.libXrandr];
  in ''
    echo "DEBUG::: Running patchelf to link binaries"
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} launcher
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} bpreport
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} gaijin_selfupdater
    mkdir -p $out/${pname}-${version}
    echo "DEBUG::: Done, proceeding."
  '';

  installPhase = ''
    mkdir -p $out/${pname}-${version}
    install -m755 -D launcher $out/${pname}-${version}/launcher
    install -m755 -D gaijin_selfupdater $out/${pname}-${version}/gaijin_selfupdater
    install -m755 -D bpreport $out/${pname}-${version}/bpreport
    install -m755 -D launcher.ico $out/${pname}-${version}/launcher.ico

    cp ca-bundle.crt $out/${pname}-${version}/ca-bundle.crt
    cp launcherr.dat $out/${pname}-${version}/launcherr.dat
    cp libsciter-gtk.so $out/${pname}-${version}/libsciter-gtk.so
    cp libsteam_api.so $out/${pname}-${version}/libsteam_api.so
    cp package.blk $out/${pname}-${version}/package.blk
    cp yupartner.blk $out/${pname}-${version}/yupartner.blk

    echo "STORE_PATH=\"$out/${pname}-${version}\"" > $out/${pname}-${version}/store_path.txt

    chmod +x "$out/${pname}-${version}/acesx86_64";
  '';

desktopItem = makeDesktopItem rec {
  name = "War Thunder";
  exec = "acesx86_64";
  icon = "launcher.ico";
  desktopName = "War Thunder";
  categories = [ "Game" ];
};




  meta = with lib; {
    homepage = "https://warthunder.com/";
    description = "Military Vehicle PVP simulator, tanks, planes, warships";
    platforms = platforms.linux;
  };
}
