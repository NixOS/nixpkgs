{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "249ebc7e2066d6393d27c1b1be3b70433f824a120b1d8274d362f1eb419e3b52";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
