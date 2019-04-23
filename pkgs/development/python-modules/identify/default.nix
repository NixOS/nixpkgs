{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3ddec4436e043c3398392b4ba8936b4ab52fa262284e767eb6c351d9b3ab5b7";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
