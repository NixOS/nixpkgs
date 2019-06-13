{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "476a1d1f6d9e7f72befff0ea4e631461882c9c1c620b92878503bf46383c8d20";
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
