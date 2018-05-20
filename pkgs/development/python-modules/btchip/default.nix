{ stdenv, buildPythonPackage, fetchPypi, hidapi, pyscard, ecdsa }:

buildPythonPackage rec {
  pname = "btchip-python";
  version = "0.1.27";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aq3wg63w49rl3wrby67284ccdr504cam2w5yhdr1n5jpcd992p5";
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
