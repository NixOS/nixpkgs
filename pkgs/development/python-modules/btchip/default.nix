{ lib, buildPythonPackage, fetchPypi, hidapi, pyscard, ecdsa }:

buildPythonPackage rec {
  pname = "btchip-python";
  version = "0.1.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34f5e0c161c08f65dc0d070ba2ff4c315ed21c4b7e0faa32a46862d0dc1b8f55";
  };

  propagatedBuildInputs = [ hidapi pyscard ecdsa ];

  # tests requires hardware
  doCheck = false;

  pythonImportsCheck = [ "btchip.btchip" ];

  meta = with lib; {
    description = "Python communication library for Ledger Hardware Wallet products";
    homepage = "https://github.com/LedgerHQ/btchip-python";
    license = licenses.asl20;
  };
}
