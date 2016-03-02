{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, libconfig
}:

stdenv.mkDerivation rec {
  basename = "compton-conf";
  version = "0.1.x";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "5a41cd8a5a7bc22198f2f58a4eb9738a8d8dbeed";
    sha256 = "26dd33cb74da8d2d8d3a1e805d5db54bf3707096ab39f073d15442a36820931d";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools
    libconfig
  ];

  preConfigure = ''cmakeFlags="-DUSE_QT5=ON"'';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "X composite manager configuration (for compton)";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
