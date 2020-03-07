{ stdenv, fetchFromGitHub, cpp-utilities, qttools, qtbase, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "qtutilities";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cp7sbj20z0vl99qhs3hi5bd6akjd9l7lqdky0p6la4c9y9w5n1w";
  };

  buildInputs = [ qtbase cpp-utilities ];
  nativeBuildInputs = [ cmake qttools ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Martchus/qtutilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2;
    maintainers = with maintainers; [ doronbehar ];
    platforms   = platforms.linux;
  };
}
