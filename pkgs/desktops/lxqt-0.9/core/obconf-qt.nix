{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, libconfig
}:

stdenv.mkDerivation rec {
  basename = "obconf-qt";
  version = "0.1.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "064f51c3d5b29f0f71bfc3e10946314c64db35e3";
    sha256 = "71b6198a26443f0a99b1add28e9a1b8d0c20d28c83f97902b58287879dcd6861";
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
