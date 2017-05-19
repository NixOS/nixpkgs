{ stdenv, fetchurl, glib, pkgconfig, perl, intltool, gobjectIntrospection, libintlOrEmpty }:
stdenv.mkDerivation rec {
  name = "libgtop-${version}";
  major = "2.34";
  version = "${major}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgtop/${major}/${name}.tar.xz";
    sha256 = "c89978a76662b18d392edbe0d1b794f5a9a399a5ccf22a02d5b9e28b5ed609e2";
  };

  propagatedBuildInputs = [ glib ];
  buildInputs = libintlOrEmpty;
  nativeBuildInputs = [ pkgconfig perl intltool gobjectIntrospection ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = {
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
