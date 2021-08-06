{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "pyjsparser";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vmDaa3eMxaUpamnY59YU8fhw+vlOGxtqxZHyrV1ylXk=";
  };

  meta = with lib; {
    homepage = "https://github.com/PiotrDabkowski/pyjsparser";
    description = "Fast JavaScript parser for Python.";
    license = licenses.mit;
    maintainers = [ payas ];
  };
}
