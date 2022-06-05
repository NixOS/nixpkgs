{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "libunarr";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/selmf/unarr/releases/download/v${version}/unarr-${version}.tar.xz";
    sha256 = "1db500k6w90qn6qb4j3zcczailmmv81q9lv4bwq516hbncg5p4sl";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/selmf/unarr";
    description = "A lightweight decompression library with support for rar, tar and zip archives";
    license = licenses.lgpl3;
  };
}
