{ stdenv, fetchurl, fetchpatch,  pkgconfig, libsamplerate, libsndfile, fftw
, vamp-plugin-sdk, ladspaH }:

stdenv.mkDerivation rec {
  pname = "rubberband";
  version = "1.8.2";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/${pname}-${version}.tar.bz2";
    sha256 = "1jn3ys16g4rz8j3yyj5np589lly0zhs3dr9asd0l9dhmf5mx1gl6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsamplerate libsndfile fftw vamp-plugin-sdk ladspaH ];

  # https://github.com/breakfastquay/rubberband/issues/17
  # In master, but there hasn't been an official release
  patches = [
    (fetchpatch {
      url = "https://github.com/breakfastquay/rubberband/commit/419a9bcf7066473b0d31e9a8a81fe0b2a8e41fed.patch";
      sha256 = "0drkfb2ahi31g4w1cawgsjjz26wszgg52yn3ih5l2ql1g25dqqn9";
    })
  ];

  meta = with stdenv.lib; {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = "https://breakfastquay.com/rubberband/";
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
