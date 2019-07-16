{ stdenv, meson, ninja, vala, gettext, itstool, fetchurl, pkgconfig, libxml2
, gtk3, glib, gtksourceview4, wrapGAppsHook, gobject-introspection, python3
, gnome3, mpfr, gmp, libsoup, libmpc, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "gnome-calculator-${version}";
  version = "3.32.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0fgpn3sc226s9fpzhik5rkkrf669037gc659ga2kn9jsyckj6p41";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext itstool wrapGAppsHook python3
    gobject-introspection # for finding vapi files
  ];

  buildInputs = [
    gtk3 glib libxml2 gtksourceview4 mpfr gmp
    gnome3.adwaita-icon-theme
    gsettings-desktop-schemas libsoup libmpc
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
