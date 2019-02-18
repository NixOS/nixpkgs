{ stdenv, meson, ninja, gettext, fetchurl, pkgconfig
, wrapGAppsHook, itstool, desktop-file-utils, python3
, glib, gtk3, evolution-data-server
, libuuid, webkitgtk, zeitgeist
, gnome3, libxml2 }:

let
  version = "3.30.3";
in stdenv.mkDerivation rec {
  name = "gnome-notes-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${stdenv.lib.versions.majorMinor version}/bijiben-${version}.tar.xz";
    sha256 = "1mkpi2i9nqpip5l15ihjcscyiri113s0705sjgh6b89164ahyn5k";
  };

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxml2 desktop-file-utils python3 wrapGAppsHook
  ];

  buildInputs = [
    glib gtk3 libuuid webkitgtk gnome3.tracker
    gnome3.gnome-online-accounts zeitgeist
    gnome3.gsettings-desktop-schemas
    evolution-data-server
    gnome3.defaultIconTheme
  ];

  mesonFlags = [
    "-Dzeitgeist=true"
    "-Dupdate_mimedb=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "bijiben";
      attrPath = "gnome3.gnome-notes";
    };
  };

  meta = with stdenv.lib; {
    description = "Note editor designed to remain simple to use";
    homepage = https://wiki.gnome.org/Apps/Notes;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
