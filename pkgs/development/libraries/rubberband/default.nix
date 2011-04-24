{ stdenv, fetchurl, pkgconfig, libsamplerate, libsndfile, fftw
, vampSDK, ladspaH }:

stdenv.mkDerivation {
  name = "rubberband-1.6.0";

  src = fetchurl {
    url = http://www.breakfastquay.com/rubberband/files/rubberband-1.6.0.tar.bz2;
    sha256 = "15n875x3bbg7nbnqbl33v5jp2p6yw779124xz4la8ysclvikklsv";
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
