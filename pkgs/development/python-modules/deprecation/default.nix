{ lib, buildPythonPackage, fetchPypi, python, packaging, unittest2 }:

buildPythonPackage rec {
  pname = "deprecation";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af3180b9aa53e5d3e0ff23934bd14963c7d6effd39c5c8c21973bf1dff8e8479";
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
