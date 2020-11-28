{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, cppunit
}:

stdenv.mkDerivation rec {
  pname = "cpp-utilities";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "04483v9bw6wp831f34fn46zj54v9y7f6qqfmx85fjxhkr3rqk4i0";
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
