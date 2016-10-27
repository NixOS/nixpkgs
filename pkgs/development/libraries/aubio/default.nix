{ stdenv, fetchurl, alsaLib, fftw, libjack2, libsamplerate
, libsndfile, pkgconfig, python2
}:

stdenv.mkDerivation rec {
  name = "aubio-0.4.1";

  src = fetchurl {
    url = "http://aubio.org/pub/${name}.tar.bz2";
    sha256 = "15f6nf76y7iyl2kl4ny7ky0zpxfxr8j3902afvd6ydnnkh5dzmr5";
  };

  buildInputs = [
    alsaLib fftw libjack2 libsamplerate libsndfile pkgconfig python2
  ];

  configurePhase = "${python2.interpreter} waf configure --prefix=$out";

  buildPhase = "${python2.interpreter} waf";

  installPhase = "${python2.interpreter} waf install";

  meta = with stdenv.lib; { 
    description = "Library for audio labelling";
    homepage = http://aubio.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
