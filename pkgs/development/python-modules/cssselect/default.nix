{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cssselect";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10h623qnp6dp1191jri7lvgmnd4yfkl36k9smqklp1qlf3iafd85";
  };

  # AttributeError: 'module' object has no attribute 'tests'
  doCheck = false;

  meta = with stdenv.lib; {
  };
}
