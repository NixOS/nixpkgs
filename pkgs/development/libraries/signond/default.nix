{ mkDerivation, lib, fetchFromGitLab, qmake, doxygen }:

mkDerivation rec {
  pname = "signond";
  version = "8.60";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = pname;
    rev = "VERSION_${version}";
    sha256 = "pFpeJ13ut5EoP37W33WrYL2LzkX/k7ZKJcRpPO5l8i4=";
  };

  nativeBuildInputs = [
    qmake
    doxygen
  ];

  preConfigure = ''
    substituteInPlace src/signond/signond.pro \
      --replace "/etc" "@out@/etc"
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/accounts-sso/signond";
    description = "Signon Daemon for Qt";
    maintainers = with maintainers; [ freezeboy  ];
    platforms = platforms.linux;
  };
}
