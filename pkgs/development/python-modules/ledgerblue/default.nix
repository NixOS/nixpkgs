{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ledgerblue";
  version = "0.1.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42cbcd74615576294142d56eb9eaa7e1b67f9dd87eeb24d713336b56e8c01c5c";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ecpy ];

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = https://github.com/LedgerHQ/blue-loader-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
