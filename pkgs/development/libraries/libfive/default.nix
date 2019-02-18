{ stdenv, fetchFromGitHub, cmake, ninja, pkgconfig, eigen,
zlib, libpng, boost, qt5, guile
}:

stdenv.mkDerivation rec {
  name = "libfive-${version}";
  version = "2018-07-01";

  src = fetchFromGitHub {
    owner  = "libfive";
    repo   = "libfive";
    rev    = "0f517dde9521d751310a22f85ee69b2c84690267";
    sha256 = "0bfxysf5f4ripgcv546il8wnw5p0d4s75kdjlwvj32549537hlz0";
  };
  nativeBuildInputs = [ cmake ninja pkgconfig ];
  buildInputs = [ eigen zlib libpng boost qt5.qtimageformats guile ];

  # Link "Studio" binary to "libfive-studio" to be more obvious:
  postFixup = ''
    ln -s "$out/bin/Studio" "$out/bin/libfive-studio"
  '';

  meta = with stdenv.lib; {
    description = "Infrastructure for solid modeling with F-Reps in C, C++, and Guile";
    homepage = https://libfive.com/;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
