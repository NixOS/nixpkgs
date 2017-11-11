{ stdenv, fetchurl, glib, pkgconfig, perl, intltool, gobjectIntrospection, libintlOrEmpty }:
stdenv.mkDerivation rec {
  name = "libgtop-${version}";
  major = "2.38";
  version = "${major}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgtop/${major}/${name}.tar.xz";
    sha256 = "04mnxgzyb26wqk6qij4iw8cxwl82r8pcsna5dg8vz2j3pdi0wv2g";
  };

  propagatedBuildInputs = [ glib ];
  buildInputs = libintlOrEmpty;
  nativeBuildInputs = [ pkgconfig perl intltool gobjectIntrospection ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = {
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
