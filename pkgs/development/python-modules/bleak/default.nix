{ lib, buildPythonPackage, isPy3k, fetchPypi
, bluez, dbus-next, pytestCheckHook, pytest-cov
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.12.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pNHz24YjB6FB9ZLC3LoXS+2qzhforflNXzG6OWFqCvk=";
  };

  postPatch = ''
    # bleak checks BlueZ's version with a call to `bluetoothctl -v` twice
    substituteInPlace bleak/__init__.py \
      --replace \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
    substituteInPlace bleak/backends/bluezdbus/client.py \
      --replace \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
  '';

  propagatedBuildInputs = [ dbus-next ];

  checkInputs = [ pytestCheckHook pytest-cov ];

  pythonImportsCheck = [ "bleak" ];

  meta = with lib; {
    description = "Bluetooth Low Energy platform Agnostic Klient for Python";
    homepage = "https://github.com/hbldh/bleak";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
