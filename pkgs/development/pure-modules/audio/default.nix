{ stdenv, fetchurl, pkgconfig, pure, portaudio, fftw, libsndfile, libsamplerate }:

stdenv.mkDerivation rec {
  baseName = "audio";
  version = "0.6";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "c1f2a5da73983efb5a54f86d57ba93713ebed20ff0c72de9b3467f10f2904ee0";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure portaudio fftw libsndfile libsamplerate ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A digital audio interface for the Pure programming language";
    homepage = http://puredocs.bitbucket.org/pure-audio.html;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
