{ stdenv, fetchFromGitHub, cmake, ninja, pkgconfig, eigen,
zlib, libpng, boost, qt5, guile
}:

stdenv.mkDerivation rec {
  name = "libfive-${version}";
  version = "2019-08-05";

  src = fetchFromGitHub {
    owner  = "libfive";
    repo   = "libfive";
    rev    = "d0e6401";
    sha256 = "0f8cyc04gjqlzs71cm2l1j6lf4kkksf0sqgz9jfpfsvdvs3q3n6w";
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
