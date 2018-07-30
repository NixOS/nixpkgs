{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hvwfpf6fmgn93abrvj88pi7sbcib32s4c5r99lw67kbziq5x129";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
