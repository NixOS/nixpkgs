{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket_client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14zv8bp62r1fwrrpbwyg9a3s5dl76lbhd8lv16xim0w55p9vvixn";
  };

  propagatedBuildInputs = [
    hidapi pycrypto pillow protobuf future ecpy python-u2flib-host pycryptodomex websocket_client
  ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = https://github.com/LedgerHQ/blue-loader-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
