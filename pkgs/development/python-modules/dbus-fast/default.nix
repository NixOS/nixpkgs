{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dbus-fast";
  version = "1.4.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vbsigiUSGeetY+1MEeQ/cO3Oj8Ah0Yg9BUPo2Gc06KU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=dbus_fast --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "dbus_fast"
    "dbus_fast.aio"
    "dbus_fast.service"
    "dbus_fast.message"
  ];

  # requires a running dbus daemon
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/Bluetooth-Devices/dbus-fast/releases/tag/v${version}";
    description = "A faster version of dbus-next";
    homepage = "https://github.com/Bluetooth-Devices/dbus-fast";
    license = licenses.mit;
    maintainers = lib.teams.home-assistant.members;
  };
}
