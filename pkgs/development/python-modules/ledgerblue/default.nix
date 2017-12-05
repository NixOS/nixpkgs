{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ledgerblue";
  version = "0.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09bsiylvgax6m47w8r0myaf61xj9j0h1spvadx6fx31qy0iqicw0";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ecpy ];

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = https://github.com/LedgerHQ/blue-loader-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
