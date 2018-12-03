{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gtk3, wrapGAppsHook
, glib, amtk, appstream-glib, gobject-introspection, python3
, webkitgtk, gettext, itstool, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "devhelp-${version}";
  version = "3.30.1";

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "036sddvhs0blqpc2ixmjdl9vxynvkn5jpgn0jxr1fxcm4rh3q07a";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool wrapGAppsHook appstream-glib gobject-introspection python3 ];
  buildInputs = [
    glib gtk3 webkitgtk amtk
    gnome3.defaultIconTheme gsettings-desktop-schemas
  ];

  doCheck = true;

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "devhelp";
      attrPath = "gnome3.devhelp";
    };
  };

  meta = with stdenv.lib; {
    description = "API documentation browser for GNOME";
    homepage = https://wiki.gnome.org/Apps/Devhelp;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
