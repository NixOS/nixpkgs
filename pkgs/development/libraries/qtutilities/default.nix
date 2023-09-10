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
  version = "6.13.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gfGVVjtzpBGrPrp2k3fOIh54EAMSicyikF1CtaO74y8=";
  };

  buildInputs = [ qtbase cpp-utilities ];
  nativeBuildInputs = [ cmake qttools ];

  cmakeFlags = ["-DBUILD_SHARED_LIBS=ON"];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/Martchus/qtutilities";
    description = "Common Qt related C++ classes and routines used by @Martchus' applications such as dialogs, widgets and models Topics";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
