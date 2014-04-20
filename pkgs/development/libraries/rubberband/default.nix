{ stdenv, fetchurl, pkgconfig, libsamplerate, libsndfile, fftw
, vampSDK, ladspaH }:

stdenv.mkDerivation {
  name = "rubberband-1.8.1";

  src = fetchurl {
    url = http://code.breakfastquay.com/attachments/download/23/rubberband-1.8.1.tar.bz2;
    sha256 = "0x9bm2nqd6w2f35w2sqcp7h5z34i4w7mdg53m0vzjhffnnq6637z";
  };

  buildInputs = [ pkgconfig libsamplerate libsndfile fftw vampSDK ladspaH ];

  meta = with stdenv.lib; {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = http://www.breakfastquay.com/rubberband/index.html;
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
