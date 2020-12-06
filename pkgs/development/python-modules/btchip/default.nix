{ stdenv, buildPythonPackage, fetchPypi, hidapi, pyscard, ecdsa }:

buildPythonPackage rec {
  pname = "btchip-python";
  version = "0.1.31";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4167f3c6ea832dd189d447d0d7a8c2a968027671ae6f43c680192f2b72c39b2c";
  };

  propagatedBuildInputs = [ hidapi pyscard ecdsa ];

  # tests requires hardware
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python communication library for Ledger Hardware Wallet products";
    homepage = "https://github.com/LedgerHQ/btchip-python";
    license = licenses.asl20;
  };
}
