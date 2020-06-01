{ stdenv, buildPythonPackage, isPy3k, fetchPypi, bluez, txdbus, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.6.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kmq2z3dhq6dd20i5w71gshjrfvyw0pkpnld8iib9ai2rz6a8aj0";
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
    maintainers = with maintainers; [ geistesk ];
  };
}
