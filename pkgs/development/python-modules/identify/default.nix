{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "432c548d6138cb57a3d8f62f079a025a29b8ae34a50dd3b496bbf661818f2bc0";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
