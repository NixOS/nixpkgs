{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "dict2xml";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZgCqMx8X7uODNhH3GJmkOnZhLKdVoVdpzyBJLEsaoBY=";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Super simple library to convert a Python dictionary into an xml string";
    homepage = "https://github.com/delfick/python-dict2xml";
    license = licenses.mit;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
