{ stdenv
, lib
, meson
, ninja
, pkg-config
, fetchFromGitHub
, dleyna-core
, glib
}:

stdenv.mkDerivation rec {
  pname = "dleyna-connector-dbus";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "phako";
    repo = pname;
    rev = "v${version}";
    sha256 = "WDmymia9MD3BRU6BOCzCIMrz9V0ACRzmEGqjbbuUmlA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dleyna-core
    glib
  ];

  meta = with lib; {
    description = "A D-Bus API for the dLeyna services";
    homepage = "https://github.com/phako/dleyna-connector-dbus";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
    license = licenses.lgpl21Only;
  };
}
