{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gobject-introspection, gnome3
, webkitgtk, libsoup, libxml2, libarchive }:

stdenv.mkDerivation rec {
  pname = "libgepub";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "16dkyywqdnfngmwsgbyga0kl9vcnzczxi3lmhm27pifrq5f3k2n7";
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection ];
  buildInputs = [ glib webkitgtk libsoup libxml2 libarchive ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "GObject based library for handling and rendering epub documents";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
