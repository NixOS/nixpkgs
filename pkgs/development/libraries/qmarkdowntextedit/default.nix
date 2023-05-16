{ lib
, stdenv
, fetchFromGitHub
, qmake
<<<<<<< HEAD
=======
, wrapQtAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "qmarkdowntextedit";
<<<<<<< HEAD
  version = "unstable-2023-04-02";
=======
  version = "unstable-2022-08-24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pbek";
    repo = pname;
<<<<<<< HEAD
    rev = "a23cc53e7e40e9dcfd0f815b2b3b6a5dc7304405";
    hash = "sha256-EYBX2SJa8o4R/zEjSFbmFxhLI726WY21XmCkWIqPeFc=";
  };

  nativeBuildInputs = [ qmake ];

  dontWrapQtApps = true;
=======
    rev = "f7ddc0d520407405b9b132ca239f4a927e3025e6";
    sha256 = "sha256-TEb2w48MZ8U1INVvUiS1XohdvnVLBCTba31AwATd/oE=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  qmakeFlags = [
    "qmarkdowntextedit-lib.pro"
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  meta = with lib; {
    description = "C++ Qt QPlainTextEdit widget with markdown highlighting and some other goodies";
    homepage = "https://github.com/pbek/qmarkdowntextedit";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
