{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pytest-subtesthack";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-67UEIDycAf3TedKvp0dofct7HtG+H8DD9Tmy3oEnYgA=";
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
