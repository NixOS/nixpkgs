{ stdenv, fetchurl, alsaLib, fftw, libjack2, libsamplerate
, libsndfile, pkgconfig, python3
}:

stdenv.mkDerivation rec {
  name = "aubio-0.4.4";

  src = fetchurl {
    url = "http://aubio.org/pub/${name}.tar.bz2";
    sha256 = "1y5zzwv9xjc649g4xrlqnim4q7pcwgzn0xrq3ijbmm5r4ckbkk9a";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib fftw libjack2 libsamplerate libsndfile python3 ];

  configurePhase = "${python3.interpreter} waf configure --prefix=$out";

  buildPhase = "${python3.interpreter} waf";

  installPhase = "${python3.interpreter} waf install";

  meta = with stdenv.lib; {
    description = "Library for audio labelling";
    homepage = http://aubio.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ goibhniu marcweber fpletz ];
    platforms = platforms.linux;
  };
}
