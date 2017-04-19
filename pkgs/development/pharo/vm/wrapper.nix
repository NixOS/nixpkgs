{ stdenv, makeDesktopItem, cog-vm, spur-vm, spur64-vm ? "none" }:

stdenv.mkDerivation rec {
  name = "pharo";
  resources = ./resources;
  desktopItem = makeDesktopItem {
    inherit name;
    desktopName = "Pharo VM";
    genericName = "Pharo Virtual Machine";
    exec = "pharo %F";
    icon = "pharo";
    terminal = "false";
    type="Application";
    startupNotify = "false";
    categories = "Development;";
    mimeType = "application/x-pharo-image";
  };
  installPhase = ''
    mkdir -p $out/bin
    substituteAll ${./wrapper.sh} $out/bin/pharo
  '';
}

