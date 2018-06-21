{ lib, buildPythonPackage, fetchPypi, python, packaging, unittest2 }:

buildPythonPackage rec {
  pname = "deprecation";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c259bfc0237f16bbe36cb32b6d81addd919b8f4bc7253738576816e82841b96";
  };

  propagatedBuildInputs = [ packaging ];

  checkInputs = [ unittest2 ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "A library to handle automated deprecations";
    homepage = https://deprecation.readthedocs.io/;
    license = licenses.asl20;
  };
}
