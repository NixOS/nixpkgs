{ stdenv, fetchFromGitHub, cmake, cppunit }:

stdenv.mkDerivation rec {
  pname = "cpp-utilities";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cghk1a0ki1063ci63imakmggwzkky1hx6lhrvc0wjfv754wsklb";
  };

  nativeBuildInputs = [ cmake ];
  checkInputs = [ cppunit ];
  # Otherwise, tests fail since the resulting shared object libc++utilities.so is only available in PWD of the make files
  checkFlagsArray = [ "LD_LIBRARY_PATH=$(PWD)" ];
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
