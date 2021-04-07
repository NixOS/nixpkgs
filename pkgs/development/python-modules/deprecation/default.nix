{ lib, buildPythonPackage, fetchPypi, python, packaging, unittest2 }:

buildPythonPackage rec {
  pname = "deprecation";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zqqjlgmhgkpzg9ss5ki8wamxl83xn51fs6gn2a8cxsx9vkbvcvj";
  };

  propagatedBuildInputs = [ packaging ];

  checkInputs = [ unittest2 ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "A library to handle automated deprecations";
    homepage = "https://deprecation.readthedocs.io/";
    license = licenses.asl20;
  };
}
