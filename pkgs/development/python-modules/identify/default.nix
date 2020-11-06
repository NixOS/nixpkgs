{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9504ba6a043ee2db0a9d69e43246bc138034895f6338d5aed1b41e4a73b1513";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
