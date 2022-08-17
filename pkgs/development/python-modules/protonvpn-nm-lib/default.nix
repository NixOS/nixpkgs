{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, substituteAll
, dbus-python
, distro
, jinja2
, keyring
, proton-client
, pygobject3
, pyxdg
, systemd
, ncurses
, networkmanager
, pkgs-systemd
, python
, xdg-utils
, makeWrapper
}:

buildPythonPackage rec {
  pname = "protonvpn-nm-lib";
  version = "3.11.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = pname;
    rev = version;
    sha256 = "sha256-kfOLhM0/jzHj+KlDrnCe571Bcmv8TvuAbXMpt3uR2L0=";
  };

  propagatedBuildInputs = [
    dbus-python
    distro
    jinja2
    keyring
    proton-client
    pygobject3
    pyxdg
    systemd
    ncurses
    networkmanager
    pkgs-systemd
    xdg-utils
  ];

  patches = [
    (substituteAll {
      src = ./0001-Patching-GIRepository.patch;
      networkmanager_path = "${networkmanager}/lib/girepository-1.0";
    })
  ];

  postPatch = ''
    substituteInPlace protonvpn_nm_lib/core/dbus/dbus_reconnect.py \
      --replace "exec_start = python_interpreter_path + \" \" + python_service_path" "exec_start = \"$out/bin/protonvpn_reconnector.py\""
  '';

  postInstall = ''
    makeWrapper ${python.interpreter} $out/bin/protonvpn_reconnector.py \
      --add-flags $out/${python.sitePackages}/protonvpn_nm_lib/daemon/dbus_daemon_reconnector.py \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

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
