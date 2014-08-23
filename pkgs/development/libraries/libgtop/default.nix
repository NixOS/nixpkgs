{ stdenv, fetchurl, glib, pkgconfig, perl, intltool }:
stdenv.mkDerivation {
  name = "libgtop-2.28.5";

  src = fetchurl {
    url = mirror://gnome/sources/libgtop/2.28/libgtop-2.28.5.tar.xz;
    sha256 = "0hik1aklcn79irgw1xf7d6cfkw8hzmy46r9jyfhp32aawisc24n8";
  };

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig perl intltool ];
}
