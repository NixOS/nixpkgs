{ stdenv, fetchFromGitHub, cpp-utilities, qttools, qtbase, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "qtutilities";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f2nir1qb0d6r1ndpsg7vpskdw08szq82mqvbwm5bi160xkrqhjf";
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
