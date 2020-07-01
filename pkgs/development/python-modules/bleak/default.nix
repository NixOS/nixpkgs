{ stdenv, buildPythonPackage, isPy3k, fetchPypi, bluez, txdbus, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.6.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dc32899d0700c5b5ed9abf642dfee28ac62b1fb5d7be5fa5a6db104dec9a03c";
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
