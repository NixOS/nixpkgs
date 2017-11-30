{ stdenv, fetchurl, gnome3, meson, ninja, pkgconfig, gtk3, intltool, glib
, udev, itstool, libxml2, wrapGAppsHook, libnotify, libcanberra_gtk3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ meson ninja intltool itstool pkgconfig libxml2 wrapGAppsHook ];
  buildInputs = [ glib gtk3 udev libnotify libcanberra_gtk3
                  gnome3.defaultIconTheme gnome3.gsettings_desktop_schemas ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-bluetooth/stable/index.html.en;
    description = "Application that let you manage Bluetooth in the GNOME destkop";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
