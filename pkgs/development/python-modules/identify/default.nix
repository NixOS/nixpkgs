{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vi9qxgnjgxdk4wj3c5ha3hjmc97j3pw1zh2cg39jprapn4rb4fq";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
