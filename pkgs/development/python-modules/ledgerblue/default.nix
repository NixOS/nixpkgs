{ lib, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket-client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.38";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df1fffc4f586eaa95b8cf910176d28997e65a3ecd43d9c0af34e46078b6b6ee3";
  };

  propagatedBuildInputs = [
    hidapi pycrypto pillow protobuf future ecpy python-u2flib-host pycryptodomex websocket-client
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "ledgerblue" ];

  meta = with lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
