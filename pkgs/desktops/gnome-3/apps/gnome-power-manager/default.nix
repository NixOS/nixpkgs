{ stdenv
, intltool
, fetchurl
, pkgconfig
, gtk3
, glib
, meson
, ninja
, upower
, desktop-file-utils
, wrapGAppsHook
, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
    intltool

    # needed by meson_post_install.sh
    glib.dev
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    glib
    upower
    gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://projects.gnome.org/gnome-power-manager/;
    description = "View battery and power statistics provided by UPower";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
