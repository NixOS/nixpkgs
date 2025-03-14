{
  stdenv,
  lib,
  fetchFromGitLab,
  qmake,
  qtbase,
  wrapQtAppsHook,
  doxygen,
}:

stdenv.mkDerivation {
  pname = "signond";
  version = "8.61-unstable-2023-11-24";

  # pinned to fork with Qt6 support
  src = fetchFromGitLab {
    owner = "nicolasfella";
    repo = "signond";
    rev = "c8ad98249af541514ff7a81634d3295e712f1a39";
    hash = "sha256-0FcSVF6cPuFEU9h7JIbanoosW/B4rQhFPOq7iBaOdKw=";
  };

  nativeBuildInputs = [
    qmake
    doxygen
    wrapQtAppsHook
  ];

  buildInputs = [ qtbase ];

  preConfigure = ''
    substituteInPlace src/signond/signond.pro \
      --replace "/etc" "@out@/etc"
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/accounts-sso/signond";
    description = "Signon Daemon for Qt";
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.linux;
  };
}
