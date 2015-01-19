{ stdenv, bash, dbus, gnused, gnugrep, kconfig, kinit, kservice, plasma-desktop
, plasma-workspace, qt5, socat, xorg }:

let startkde = ./startkde.in; in

stdenv.mkDerivation {
  name = "startkde-0.1";
  phases = "installPhase";

  inherit bash gnused gnugrep kconfig kinit kservice qt5 socat;
  inherit (xorg) mkfontdir xmessage xprop xrdb xset xsetroot;
  dbus_tools = dbus.tools;
  plasmaWorkspace = plasma-workspace;
  plasmaDesktop = plasma-desktop;
  startupconfigkeys = ./startupconfigkeys;
  kdeglobals = ./kdeglobals;

  installPhase = ''
    mkdir -p $out/bin
    substituteAll ${startkde} $out/bin/startkde
    chmod +x $out/bin/startkde
  '';

  meta = {
    description = "Custom startkde script for Nixpkgs";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
    license = with stdenv.lib.licenses; [ gpl2Plus ];
  };
}
