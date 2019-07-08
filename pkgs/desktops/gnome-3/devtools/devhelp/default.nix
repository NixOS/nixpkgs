{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gtk3, wrapGAppsHook
, glib, amtk, appstream-glib, gobject-introspection, python3
, webkitgtk, gettext, itstool, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "devhelp-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "06sa83zggk29wcg75fl3gqh0rmi7cd3gsbk09a2z23r7vpy7xanq";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool wrapGAppsHook appstream-glib gobject-introspection python3 ];
  buildInputs = [
    glib gtk3 webkitgtk amtk
    gnome3.adwaita-icon-theme gsettings-desktop-schemas
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
