{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ledgerblue";
  version = "0.1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac403b074337b9b58cae97ea00b3d94fc8efeea1717a80c49e79dc8aad6fc58f";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ecpy ];

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = https://github.com/LedgerHQ/blue-loader-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
