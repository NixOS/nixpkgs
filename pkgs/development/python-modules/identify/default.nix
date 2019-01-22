{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08826e68e39e7de53cc2ddd8f6228a4e463b4bacb20565e5301c3ec690e68d27";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
