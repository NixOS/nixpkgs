{ stdenv, fetchurl, alsaLib, fftw, libjack2, libsamplerate
, libsndfile, pkgconfig, python
}:

stdenv.mkDerivation rec {
  name = "aubio-0.4.7";

  src = fetchurl {
    url = "https://aubio.org/pub/${name}.tar.bz2";
    sha256 = "0hd0kzfmr46am00ygxar8alrldv92c5azqy701iilfmbqpz4mvfb";
  };

  nativeBuildInputs = [ pkgconfig python ];
  buildInputs = [ alsaLib fftw libjack2 libsamplerate libsndfile ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "Library for audio labelling";
    homepage = https://aubio.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ goibhniu marcweber fpletz ];
    platforms = platforms.linux;
  };
}
