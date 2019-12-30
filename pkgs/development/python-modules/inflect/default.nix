{ buildPythonPackage, fetchPypi, setuptools_scm, nose, six, importlib-metadata }:

buildPythonPackage rec {
  pname = "inflect";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee7c9b7c3376d06828b205460afb3c447b5d25dd653171db249a238f3fc2c18a";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six importlib-metadata ];
  checkInputs = [ nose ];
}
