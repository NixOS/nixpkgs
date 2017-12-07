{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "flite-1.9.0";

  src = fetchurl {
    url = "http://www.festvox.org/bard/${name}-current.tar.bz2";
    sha256 = "197cc2a1f045b1666a29a9b5f035b3d676db6db94a4439d99a03b65e551ae2e0";
  };

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = ''
    --enable-shared
  '';

  meta = {
    description = "A small, fast run-time speech synthesis engine";
    homepage = http://www.festvox.org/flite/;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}
