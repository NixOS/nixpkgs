{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "flite-2.0.0";

  src = fetchurl {
    url = "http://www.festvox.org/flite/packed/flite-2.0/${name}-release.tar.bz2";
    sha256 = "04g4r83jh4cl0irc8bg7njngcah7749956v9s6sh552kzmh3i337";
  };

  patches = [ ./fix-rpath.patch ];

  configureFlags = [ "--enable-shared" ];

  enableParallelBuilding = true;

  meta = {
    description = "A small, fast run-time speech synthesis engine";
    homepage = http://www.festvox.org/flite/;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}
