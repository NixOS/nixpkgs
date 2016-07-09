{stdenv, fetchurl, zlib, libpng, freetype, libjpeg, fontconfig}:

stdenv.mkDerivation rec {
  name = "gd-${version}";
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${name}/libgd-${version}.tar.xz";
    sha256 = "1311g5mva2xlzqv3rjqjc4jjkn5lzls4skvr395h633zw1n7b7s8";
  };

  buildInputs = [zlib libpng freetype];

  propagatedBuildInputs = [libjpeg fontconfig]; # urgh

  configureFlags = "--without-x";

  meta = {
    homepage = http://www.libgd.org/;
    description = "An open source code library for the dynamic creation of images by programmers";
  };
}
