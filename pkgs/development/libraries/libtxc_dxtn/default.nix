{ stdenv, fetchurl, autoreconfHook, libGL, libGLU }:

let version = "1.0.1"; in

stdenv.mkDerivation rec {
  pname = "libtxc_dxtn";
  inherit version;

  src = fetchurl {
    url = "https://people.freedesktop.org/~cbrill/libtxc_dxtn/${pname}-${version}.tar.bz2";
    sha256 = "0q5fjaknl7s0z206dd8nzk9bdh8g4p23bz7784zrllnarl90saa5";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libGL libGLU ];

  meta = with stdenv.lib; {
    homepage = http://dri.freedesktop.org/wiki/S3TC;
    repositories.git = git://people.freedesktop.org/~mareko/libtxc_dxtn;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
