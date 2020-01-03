{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7782115794ec28b011702815d9f5e532244560cd2bf0789c4f09381d43befd90";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
