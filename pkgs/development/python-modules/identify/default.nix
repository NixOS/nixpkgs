{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.5.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "943cd299ac7f5715fcb3f684e2fc1594c1e0f22a90d15398e5888143bd4144b5";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
