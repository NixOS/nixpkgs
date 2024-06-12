{ stdenv, lib, fetchFromGitHub, cmake, qtbase, qtquickcontrols2, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "dotherside";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "filcuc";
    repo = "dotherside";
    rev = "v${version}";
    hash = "sha256-o6RMjJz9vtfCsm+F9UYIiYPEaQn+6EU5jOTLhNHCwo4=";
  };

  buildInputs = [ qtbase qtquickcontrols2 ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  meta = with lib; {
    description = "A C language library for creating bindings for the Qt QML language";
    homepage = "https://filcuc.github.io/dotherside";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ annaaurora ];
  };
}
