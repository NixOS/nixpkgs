{ stdenv, fetchurl, glib, pkgconfig, perl, intltool }:
stdenv.mkDerivation {
  name = "libgtop-2.28.4";

  src = fetchurl {
    url = mirror://gnome/sources/libgtop/2.28/libgtop-2.28.4.tar.xz;
    sha256 = "1n71mg82k8m7p6kh06vgb1hk4y9cqwk1lva53pl7w9j02pyrqqdn";
  };

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig perl intltool ];
}
