{ stdenv, meson, ninja, vala, gettext, itstool, fetchurl, pkgconfig, libxml2
, gtk3, glib, gtksourceview3, wrapGAppsHook, gobject-introspection, python3
, gnome3, mpfr, gmp, libsoup, libmpc }:

stdenv.mkDerivation rec {
  name = "gnome-calculator-${version}";
  version = "3.30.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0qkzcmj51cjmljxl1nc84h6jgq1a51xj4g6jwh3ymgm19m3sqypc";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext itstool wrapGAppsHook python3
    gobject-introspection # for finding vapi files
  ];

  buildInputs = [
    gtk3 glib libxml2 gtksourceview3 mpfr gmp
    gnome3.defaultIconTheme
    gnome3.gsettings-desktop-schemas libsoup libmpc
  ];

  doCheck = true;

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-calculator";
      attrPath = "gnome3.gnome-calculator";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Calculator;
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
