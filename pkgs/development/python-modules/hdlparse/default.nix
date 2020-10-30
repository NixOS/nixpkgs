{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "hdlparse";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb6230ed1e7a04a8f82f8d3fb59791d0751ae35e5b8e58dbbf2cbcf100d0d0f2";
  };

  #This module does not contain any tests.
  doCheck = false;

  meta = with lib; {
    homepage = "https://kevinpt.github.io/hdlparse/";
    description = "Rudimentary parser for VHDL and Verilog";
    license = licenses.mit;
    maintainers = with maintainers; [ elliottvillars ];
  };
}

