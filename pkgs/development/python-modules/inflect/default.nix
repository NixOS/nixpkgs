{ buildPythonPackage, fetchPypi, setuptools_scm, nose, six }:

buildPythonPackage rec {
  pname = "inflect";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ded1b2a6fcf0fc0397419c7727f131a93b67b80d899f2973be7758628e12b73";
  };

  buildInputs = [ setuptools_scm ];
  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];
}
