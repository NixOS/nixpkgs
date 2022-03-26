{ lib, stdenv, fetchurl, pkg-config, pure, portaudio, fftw, libsndfile, libsamplerate }:

stdenv.mkDerivation rec {
  pname = "pure-audio";
  version = "0.6";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-audio-${version}.tar.gz";
    sha256 = "c1f2a5da73983efb5a54f86d57ba93713ebed20ff0c72de9b3467f10f2904ee0";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure portaudio fftw libsndfile libsamplerate ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A digital audio interface for the Pure programming language";
    homepage = "http://puredocs.bitbucket.org/pure-audio.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
