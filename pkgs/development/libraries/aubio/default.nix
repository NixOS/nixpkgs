{ stdenv, fetchurl, alsaLib, fftw, libjack2, libsamplerate
, libsndfile, pkgconfig, python3
}:

stdenv.mkDerivation rec {
  name = "aubio-0.4.5";

  src = fetchurl {
    url = "http://aubio.org/pub/${name}.tar.bz2";
    sha256 = "1xkshac4wdm7r5sc04c38d6lmvv5sk4qrb5r1yy0xgsgdx781hkh";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib fftw libjack2 libsamplerate libsndfile python3 ];

  configurePhase = "${python3.interpreter} waf configure --prefix=$out";

  buildPhase = "${python3.interpreter} waf";

  installPhase = "${python3.interpreter} waf install";

  meta = with stdenv.lib; {
    description = "Library for audio labelling";
    homepage = https://aubio.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ goibhniu marcweber fpletz ];
    platforms = platforms.linux;
  };
}
