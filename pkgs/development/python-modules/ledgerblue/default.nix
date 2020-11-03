{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket_client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.34";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9553d496fbc6b612d98cc9db2f1648c1bcb63939c988ee1520e8fcb9bd77b24";
  };

  requiredPythonModules = [
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
