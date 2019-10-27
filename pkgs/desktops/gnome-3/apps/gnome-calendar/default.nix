{ stdenv, fetchurl, meson, ninja, pkgconfig, wrapGAppsHook, libdazzle, libgweather, geoclue2, geocode-glib, python3
, gettext, libxml2, gnome3, gtk3, evolution-data-server, libsoup
, glib, gnome-online-accounts, gsettings-desktop-schemas }:

let
  pname = "gnome-calendar";
  version = "3.34.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1bnmd191044zn2kr6f5vg7sm5q59qf7z652awll1f7s6ahijr8rw";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext libxml2 wrapGAppsHook python3 ];
  buildInputs = [
    gtk3 evolution-data-server libsoup glib gnome-online-accounts libdazzle libgweather geoclue2 geocode-glib
    gsettings-desktop-schemas gnome3.adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x build-aux/meson/meson_post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Calendar;
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
