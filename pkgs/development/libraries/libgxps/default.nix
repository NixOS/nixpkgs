{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gobject-introspection, cairo
, libarchive, freetype, libjpeg, libtiff, gnome3, lcms2
}:

stdenv.mkDerivation rec {
  pname = "libgxps";
  version = "0.3.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "157s4c9gjjss6yd7qp7n4q6s72gz1k4ilsx4xjvp357azk49z4qs";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection ];
  buildInputs = [ glib cairo freetype libjpeg libtiff lcms2 ];
  propagatedBuildInputs = [ libarchive ];

  mesonFlags = [
    "-Denable-test=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "A GObject based library for handling and rendering XPS documents";
    homepage = https://wiki.gnome.org/Projects/libgxps;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
