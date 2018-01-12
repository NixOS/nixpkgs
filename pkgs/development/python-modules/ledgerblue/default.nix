{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ledgerblue";
  version = "0.1.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eba56b887339fb5f8582771e4e398df4fa5a017183b908d4f8950588157c1504";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ecpy ];

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = https://github.com/LedgerHQ/blue-loader-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
