{ buildPythonPackage, fetchPypi, setuptools_scm, nose, six }:

buildPythonPackage rec {
  pname = "inflect";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98cf5d82952ed8bf1cf9236c6058e9a21bc66172ecb907969d907741f91388b5";
  };

  buildInputs = [ setuptools_scm ];
  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];
}
