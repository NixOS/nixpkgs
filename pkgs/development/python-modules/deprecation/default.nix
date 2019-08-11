{ lib, buildPythonPackage, fetchPypi, python, packaging, unittest2 }:

buildPythonPackage rec {
  pname = "deprecation";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "68071e5ae7cd7e9da6c7dffd750922be4825c7c3a6780d29314076009cc39c35";
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
