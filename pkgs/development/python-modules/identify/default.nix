{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "110ed090fec6bce1aabe3c72d9258a9de82207adeaa5a05cd75c635880312f9a";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
