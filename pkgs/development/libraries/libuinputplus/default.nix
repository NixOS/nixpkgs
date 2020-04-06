{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libuinputplus";
  version = "2019-10-01";

  src  = fetchFromGitHub {
    owner  = "YukiWorkshop";
    repo   = "libuInputPlus";
    rev    = "962f180b4cc670e1f5cc73c2e4d5d196ae52d630";
    sha256 = "0jy5i7bmjad7hw1qcyjl4swqribp2027s9g3609zwj7lj8z5x0bg";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Easy-to-use uinput library in C++";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = with platforms; linux;
  };
}
