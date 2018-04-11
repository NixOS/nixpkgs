{ lib, buildPythonPackage, fetchPypi, python, packaging, unittest2 }:

buildPythonPackage rec {
  pname = "deprecation";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8d0dc5a17d7d551730e5f23ff3a53fc9e438364b9efb47d41c3e9b05522eabe";
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
