{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12adarxndb9f5kgbfch9644h86jhbf6vc1d5c5iiqnjqws9n495b";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
