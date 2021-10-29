{ stdenv
, lib
, fetchFromGitHub
, cpp-utilities
, qttools
, qtbase
, cmake
}:

stdenv.mkDerivation rec {
  pname = "qtutilities";
  version = "6.5.1";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J5yPezXU+AIvmLTBs4lWU35DvfP+0EuuhOJpxAzwRtw=";
  };

  buildInputs = [ qtbase cpp-utilities ];
  nativeBuildInputs = [ cmake qttools ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/Martchus/qtutilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms   = platforms.linux;
  };
}
