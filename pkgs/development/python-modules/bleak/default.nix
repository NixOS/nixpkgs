{ stdenv, buildPythonPackage, isPy3k, fetchPypi, bluez, txdbus, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.7.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "25f630cf558efda5cbf620d921b85a80ae963c537feaa18cc934f7fa38dc482d";
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
