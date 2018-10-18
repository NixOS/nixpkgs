{ buildPythonPackage, fetchPypi, setuptools_scm, nose, six }:

buildPythonPackage rec {
  pname = "inflect";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec42f5d5d2baa54ba6e3fa23698554c09362dd478cc66b3c28c5d0b76d7d0581";
  };

  buildInputs = [ setuptools_scm ];
  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];
}
