{ lib, stdenv, fetchurl, meson, ninja, pkg-config, glib, gobject-introspection, cairo
, libarchive, freetype, libjpeg, libtiff, gnome3, lcms2
}:

stdenv.mkDerivation rec {
  pname = "libgxps";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "bSeGclajXM+baSU+sqiKMrrKO5fV9O9/guNmf6Q1JRw=";
  };

  nativeBuildInputs = [ meson ninja pkg-config gobject-introspection ];
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

  meta = with lib; {
    description = "A GObject based library for handling and rendering XPS documents";
    homepage = "https://wiki.gnome.org/Projects/libgxps";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
