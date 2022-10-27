{ lib
, stdenv
, fetchFromGitHub
, qmake
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qmarkdowntextedit";
  version = "unstable-2022-08-24";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = pname;
    rev = "f7ddc0d520407405b9b132ca239f4a927e3025e6";
    sha256 = "sha256-TEb2w48MZ8U1INVvUiS1XohdvnVLBCTba31AwATd/oE=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

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
