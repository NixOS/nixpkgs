{ stdenv, fetchFromGitHub, alsaLib }:

stdenv.mkDerivation {
  name = "flite-2.1.0";

  src = fetchFromGitHub {
    owner  = "festvox";
    repo   = "flite";
    rev    = "d673f65b2c4a8cd3da7447079309a6dc4bcf1a5e";
    sha256 = "1kx43jvdln370590gfjhxxz3chxfi6kq18504wmdpljib2l0grjq";
  };

  buildInputs = [ alsaLib ];

  configureFlags = [
    "--enable-shared"
    "--with-audio=alsa"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A small, fast run-time speech synthesis engine";
    homepage = http://www.festvox.org/flite/;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}
