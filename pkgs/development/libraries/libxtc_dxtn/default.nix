{ stdenv, fetchurl, mesa }:

stdenv.mkDerivation rec {
  name = "libtxc_dxtn-1.0.1";

  src = fetchurl {
    url = "people.freedesktop.org/~cbrill/libtxc_dxtn/${name}.tar.bz2";
    sha256 = "0q5fjaknl7s0z206dd8nzk9bdh8g4p23bz7784zrllnarl90saa5";
  };

  postUnpack = ''
    tar xf ${mesa.src} --wildcards '*/include/'
    export NIX_CFLAGS_COMPILE="-I $NIX_BUILD_TOP/[mM]esa*/include"
  '';
}
