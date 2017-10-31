{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "libqtxdg-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "libqtxdg";
    rev = version;
    sha256 = "1s5jw4q6gcivk7mc95ir9q2nry4yyhfwy039ddf5ymh79nynv8vy";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase qt5.qtsvg ];

  meta = with stdenv.lib; {
    description = "Qt implementation of freedesktop.org xdg specs";
    homepage = https://github.com/lxde/libqtxdg;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
