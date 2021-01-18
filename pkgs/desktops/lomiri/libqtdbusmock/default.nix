{ mkDerivation, lib, fetchFromGitHub
, cmake, cmake-extras
, qtbase, libqtdbustest, networkmanager
}:

mkDerivation rec {
  pname = "libqtdbusmock-unstable";
  version = "2019-09-09";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "libqtdbusmock";
    rev = "1e9fd84aa31c7b858b90e2bbbdcadf081549fa65";
    sha256 = "1i1lwapnn9jk7wa8v4x88lc175snqzljz2773rbqfwa0i1rccb7g";
  };

  nativeBuildInputs = [ cmake cmake-extras ];

  buildInputs = [ qtbase libqtdbustest networkmanager ];

  meta= with lib; {
    description = "Library for mocking DBus interactions using Qt";
    longDescription = ''
      A simple library for mocking DBus services with a Qt API.
    '';
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
