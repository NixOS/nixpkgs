{ stdenv, fetchurl, autoreconfHook, libGLU_combined }:

let version = "1.0.1"; in

stdenv.mkDerivation rec {
  name = "libtxc_dxtn-${version}";

  src = fetchurl {
    url = "http://people.freedesktop.org/~cbrill/libtxc_dxtn/${name}.tar.bz2";
    sha256 = "0q5fjaknl7s0z206dd8nzk9bdh8g4p23bz7784zrllnarl90saa5";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libGLU_combined ];

  meta = {
    homepage = http://dri.freedesktop.org/wiki/S3TC;
    repositories.git = git://people.freedesktop.org/~mareko/libtxc_dxtn;
    platforms = stdenv.lib.platforms.unix;
  };
}
