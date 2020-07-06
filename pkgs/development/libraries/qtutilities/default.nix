{ stdenv, fetchFromGitHub, cpp-utilities, qttools, qtbase, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "qtutilities";
  version = "6.0.6";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g3f18530w5f8dlzrh45k868hspga5p3m8qpz7pcg3nsdjda8cwz";
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
