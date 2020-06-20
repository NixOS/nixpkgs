{ stdenv, buildPythonPackage, fetchPypi, hidapi, pyscard, ecdsa }:

buildPythonPackage rec {
  pname = "btchip-python";
  version = "0.1.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10yxwlsr99gby338rsnczkfigcy36fiajpkr6f44438qlvbx02fs";
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
