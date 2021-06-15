{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pytest-subtesthack";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0711e5d04c291ac9ac6c9eff447ec2811b1d23ccdfe1417d16d4f96481efcbe6";
  };

  buildInputs = [ pytest ];

  # no upstream test
  doCheck = false;

  meta = with lib; {
    description = "Terrible plugin to set up and tear down fixtures within the test function itself";
    homepage = "https://github.com/untitaker/pytest-subtesthack";
    license = licenses.publicDomain;
  };
}
