{ stdenv, fetchurl, pkgconfig, meson, ninja, gettext, gnome3, libxslt, packagekit, polkit
, fontconfig, libcanberra_gtk3, systemd, libnotify, wrapGAppsHook, dbus_glib, dbus_libs, desktop_file_utils }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${dbus_glib.dev}/include/dbus-1.0 -I${dbus_libs.dev}/include/dbus-1.0";

  nativeBuildInputs = [ pkgconfig meson ninja gettext wrapGAppsHook desktop_file_utils ];
  buildInputs = [ libxslt gnome3.gtk packagekit fontconfig systemd polkit
                  libcanberra_gtk3 libnotify dbus_glib dbus_libs ];

  prePatch = "patchShebangs meson_post_install.sh";

  meta = with stdenv.lib; {
    homepage = https://www.freedesktop.org/software/PackageKit/;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    description = "Tools for installing software on the GNOME desktop using PackageKit";
  };
}
