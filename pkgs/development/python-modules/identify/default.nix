{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z8xjvpkj599h3s76q05y10iysjjky7b0s5g3zicfyxhzm7x59a3";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
