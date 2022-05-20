{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, substituteAll
, distro
, jinja2
, keyring
, proton-client
, pygobject3
, pyxdg
, systemd
, networkmanager
}:

buildPythonPackage rec {
  pname = "protonvpn-nm-lib";
  version = "3.9.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = pname;
    rev = version;
    sha256 = "sha256-yV3xeIyPc2DJj5DOa5PA1MHt00bjJ/Y9zZK77s/XRAA=";
  };

  propagatedBuildInputs = [
    distro
    jinja2
    keyring
    proton-client
    pygobject3
    pyxdg
    systemd
  ];

  patches = [
    (substituteAll {
      src = ./0001-Patching-GIRepository.patch;
      networkmanager_path = "${networkmanager}/lib/girepository-1.0";
    })
  ];

  # Checks cannot be run in the sandbox
  # "Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory"
  doCheck = false;

  pythonImportsCheck = [ "protonvpn_nm_lib" ];

  meta = with lib; {
    description = "ProtonVPN NetworkManager Library intended for every ProtonVPN service user";
    homepage = "https://github.com/ProtonVPN/protonvpn-nm-lib";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = platforms.linux;
  };
}
