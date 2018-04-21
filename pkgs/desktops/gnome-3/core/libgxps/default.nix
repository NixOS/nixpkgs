{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gobjectIntrospection, cairo
, libarchive, freetype, libjpeg, libtiff, gnome3
}:

let
  pname = "libgxps";
  version = "0.3.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "412b1343bd31fee41f7204c47514d34c563ae34dafa4cc710897366bd6cd0fae";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gobjectIntrospection ];
  buildInputs = [ glib cairo freetype libjpeg libtiff ];
  propagatedBuildInputs = [ libarchive ];

  mesonFlags = [
    "-Denable-test=false"
    "-Dwith-liblcms2=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
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
