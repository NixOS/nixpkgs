{ stdenv, buildPythonPackage, fetchPypi, hidapi, pyscard, ecdsa }:

buildPythonPackage rec {
  pname = "btchip-python";
  version = "0.1.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mraf2lmh70b038k934adxi7d40431j7yq93my3aws99f5xccsb8";
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
