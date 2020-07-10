{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "105n1prgmzkzdwr8q0bdx82nj7i8p3af1abh864k2fcyjwmpzl64";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
