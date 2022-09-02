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
  version = "6.7.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RjVmrdUHDBelwagWD5Mx+S3tdFO7I0+8RmFR7hwoe8o=";
  };

  buildInputs = [ qtbase cpp-utilities ];
  nativeBuildInputs = [ cmake qttools ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/Martchus/qtutilities";
    description = "Common Qt related C++ classes and routines used by @Martchus' applications such as dialogs, widgets and models Topics";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms   = platforms.linux;
  };
}
