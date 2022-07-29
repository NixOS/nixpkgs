{ lib
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
  version = "0.14.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dg5bsegECH92JXa5uVY9Y7R9UhsWUpiOKMPLXmS2GZA=";
  };

  propagatedBuildInputs = [
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
