{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c3646d765127b003d2bed8db1e125d68f5f83ad0cd85e21c908ef87a5e24be1";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
