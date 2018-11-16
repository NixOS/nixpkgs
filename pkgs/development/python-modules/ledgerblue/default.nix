{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb7ac6389ad13d3c9baa149b527e2cb5798e749e2b6729e5fe8437092ece6164";
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
