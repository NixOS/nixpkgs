{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket_client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c81553a08cdf56c26164b8b0e13400e0a963492d3122afdc82dcf906fafcbf41";
  };

  propagatedBuildInputs = [
    hidapi pycrypto pillow protobuf future ecpy python-u2flib-host pycryptodomex websocket_client
  ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
