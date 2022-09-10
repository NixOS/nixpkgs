{ lib
, async-timeout
, bluez
, buildPythonPackage
, dbus-next
, fetchPypi
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pUn0PjxdjeRkxytLkFU0w/R4F0bpgV7NUxtyVd4uGcc=";
  };

  propagatedBuildInputs = [
    async-timeout
    dbus-next
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # bleak checks BlueZ's version with a call to `bluetoothctl --version`
    substituteInPlace bleak/backends/bluezdbus/__init__.py \
      --replace \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
  '';

  pythonImportsCheck = [
    "bleak"
  ];

  meta = with lib; {
    description = "Bluetooth Low Energy platform agnostic client";
    homepage = "https://github.com/hbldh/bleak";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
