{ stdenv, buildPythonPackage, isPy3k, fetchPypi, bluez, txdbus, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.8.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1121adc5be6eec2d6ec3944c01d05cbbc0e88c85546e718b7ea7b65c1fb766ca";
  };

  postPatch = ''
    # bleak checks BlueZ's version with a call to `bluetoothctl -v` twice
    substituteInPlace bleak/__init__.py \
      --replace \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
    substituteInPlace bleak/backends/bluezdbus/client.py \
      --replace \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
  '';

  propagatedBuildInputs = [ txdbus ];
  checkInputs = [ pytest pytestcov ];

  checkPhase = "AGENT_OS=linux py.test";

  meta = with stdenv.lib; {
    description = "Bluetooth Low Energy platform Agnostic Klient for Python";
    homepage = "https://github.com/hbldh/bleak";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
