{ stdenv, fetchurl, pkgconfig, libsamplerate, libsndfile, fftw
, vampSDK, ladspaH }:

stdenv.mkDerivation {
  name = "rubberband-1.3";

  src = fetchurl {
    url = http://www.breakfastquay.com/rubberband/files/rubberband-1.3.tar.bz2;
    sha256 = "0g1bihjzagp9mx9zppjyd9566dfdqh38a1ghwsd7c245hv2syri8";
  };

  buildInputs = [ pkgconfig libsamplerate libsndfile fftw vampSDK ladspaH ];

  meta = { 
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = http://www.breakfastquay.com/rubberband/index.html;
    license = ["GPL"]; # commercial license availible as well, see homepage. You'll get some more optimized routines
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
