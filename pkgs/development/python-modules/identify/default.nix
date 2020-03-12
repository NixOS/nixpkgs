{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15kbcgqz6zf9qqvyw3pwy611knv1lyaqmc213ivmqciq3zifn96q";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
