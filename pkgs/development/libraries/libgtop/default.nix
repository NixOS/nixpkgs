{ stdenv, fetchurl, glib, pkgconfig, perl, intltool, gobjectIntrospection }:
stdenv.mkDerivation {
  name = "libgtop-2.32.0";

  src = fetchurl {
    url = mirror://gnome/sources/libgtop/2.32/libgtop-2.32.0.tar.xz;
    sha256 = "13hpml2vfm23816qggr5fvxj75ndb1dq4rgmi7ik6azj69ij8hw4";
  };

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig perl intltool gobjectIntrospection ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
