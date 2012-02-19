{ stdenv, fetchurl, pkgconfig, libsamplerate, libsndfile, fftw
, vampSDK, ladspaH }:

stdenv.mkDerivation {
  name = "rubberband-1.7.0";

  src = fetchurl {
    url = http://code.breakfastquay.com/attachments/download/23/rubberband-1.7.0.tar.bz2;
    sha256 = "10pnfzaiws6bi17qlyj3r0alj2nvm11pkd14nms6yxas8c7gwdw0";
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
