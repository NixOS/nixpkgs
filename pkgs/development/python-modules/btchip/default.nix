{ stdenv, buildPythonPackage, fetchPypi, hidapi, pyscard, ecdsa }:

buildPythonPackage rec {
  pname = "btchip-python";
  version = "0.1.21";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16g9l3rpxpvvkdx08mgy0ligvsfcpzdrh4hplj104cpprrbsqd6v";
  };

  propagatedBuildInputs = [ hidapi pyscard ecdsa ];

  meta = with stdenv.lib; {
    description = "Python communication library for Ledger Hardware Wallet products";
    homepage = "https://github.com/LedgerHQ/btchip-python";
    license = licenses.asl20;
  };
}
