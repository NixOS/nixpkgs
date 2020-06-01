{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19zk3qmcf0afbcbfnj7cmmgr47pxhjqwa1bfdc3fp60yy10kvbgr";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
