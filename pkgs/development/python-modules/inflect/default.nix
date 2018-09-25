{ buildPythonPackage, fetchPypi, setuptools_scm, nose, six }:

buildPythonPackage rec {
  pname = "inflect";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ll34l5b2wsbcw9i2hvkhmq6szxrp7fzc2hjmpz1cvny81bhg3kx";
  };

  buildInputs = [ setuptools_scm ];
  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];
}
