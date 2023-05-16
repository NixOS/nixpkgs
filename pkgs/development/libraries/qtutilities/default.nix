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
<<<<<<< HEAD
  version = "6.13.1";
=======
  version = "6.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ic1Xnle1fGZ5elf0yH0BF+3spAmIo9kP62WhXLmBVNc=";
=======
    hash = "sha256-zkuVD6TH3eHFMu31PmKF2qlQ3itwWHMzVp0ZjdspWTk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ qtbase cpp-utilities ];
  nativeBuildInputs = [ cmake qttools ];

<<<<<<< HEAD
  cmakeFlags = ["-DBUILD_SHARED_LIBS=ON"];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/Martchus/qtutilities";
    description = "Common Qt related C++ classes and routines used by @Martchus' applications such as dialogs, widgets and models Topics";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
