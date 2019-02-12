{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15206e92220d96512b357a9a740bc91b8b33b42b9164fe3b56c4c3aedf882cdc";
  };

  propagatedBuildInputs = [
    hidapi pycrypto pillow protobuf future ecpy python-u2flib-host pycryptodomex
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
