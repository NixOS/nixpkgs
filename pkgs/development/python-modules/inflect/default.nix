{ buildPythonPackage, fetchPypi, setuptools_scm, nose, six }:

buildPythonPackage rec {
  pname = "inflect";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wrbw4l8cxg77fbz56fqh1xvd4qs2dzp5iqrfhww03ygdwm1pvad";
  };

  buildInputs = [ setuptools_scm ];
  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];
}
