{ stdenv, fetchurl, alsaLib, fftw, libjack2, libsamplerate
, libsndfile, pkgconfig, python2
}:

stdenv.mkDerivation rec {
  name = "aubio-0.4.3";

  src = fetchurl {
    url = "http://aubio.org/pub/${name}.tar.bz2";
    sha256 = "1azarklqggch8kkz3gbqwi2vlb6ld4lidyhp34qawr0c7h3xnb5n";
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
    maintainers = with maintainers; [ goibhniu marcweber fpletz ];
    platforms = platforms.linux;
  };
}
