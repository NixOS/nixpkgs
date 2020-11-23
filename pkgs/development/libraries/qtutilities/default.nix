{ stdenv, fetchFromGitHub, cpp-utilities, qttools, qtbase, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "qtutilities";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vHx2JMPqioY8jUpBOIFdhhN1mIUV3LS8ayQOo3g7bY0=";
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
