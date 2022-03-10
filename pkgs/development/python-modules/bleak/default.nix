{ lib, buildPythonPackage, isPy3k, fetchPypi
, bluez, dbus-next, pytestCheckHook, pytest-cov
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.14.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fkq8q54s9apqiamdd8vgrhk5p02w5w281q93dfnrd37xv7ysk6h";
  };

  postPatch = ''
    # bleak checks BlueZ's version with a call to `bluetoothctl --version`
    substituteInPlace bleak/backends/bluezdbus/__init__.py \
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
