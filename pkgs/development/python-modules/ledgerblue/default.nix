{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3969b3c375c0f3fb60ff1645621ebf2f39fb697a53851620705f27ed7b283097";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ecpy ];

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = https://github.com/LedgerHQ/blue-loader-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
