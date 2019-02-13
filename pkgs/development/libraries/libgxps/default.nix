{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gobject-introspection, cairo
, libarchive, freetype, libjpeg, libtiff, gnome3, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "libgxps";
  version = "0.3.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "412b1343bd31fee41f7204c47514d34c563ae34dafa4cc710897366bd6cd0fae";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-10733-1.patch";
      url = https://gitlab.gnome.org/GNOME/libgxps/commit/b458226e162fe1ffe7acb4230c114a52ada5131b.patch;
      sha256 = "0pqg9iwkg69qknj7vkgn26c32fndy55byxivd4km0vjfhfyx69hd";
    })
    (fetchpatch {
      name = "CVE-2018-10733-2.patch";
      url = https://gitlab.gnome.org/GNOME/libgxps/commit/133fe2a96e020d4ca65c6f64fb28a404050ebbfd.patch;
      sha256 = "19n01x8zs05wf801mkz4mypvapph7h941md3hr3rj0ry6r88pkir";
    })
  ];

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection ];
  buildInputs = [ glib cairo freetype libjpeg libtiff ];
  propagatedBuildInputs = [ libarchive ];

  mesonFlags = [
    "-Denable-test=false"
    "-Dwith-liblcms2=false"
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
