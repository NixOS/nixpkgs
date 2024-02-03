{ stdenv, lib, fetchFromGitLab, qmake, qtbase, wrapQtAppsHook, doxygen }:

stdenv.mkDerivation rec {
  pname = "signond";
  version = "8.61";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = pname;
    rev = "VERSION_${version}";
    sha256 = "sha256-d7JZmGpjIvSN9l1nvKbBZjF0OR5L5frPTGHF/pNEqHE=";
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
