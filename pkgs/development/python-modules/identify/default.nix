{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b435803dc79a0f0ce887887a62ad360f3a9e8162ac0db9ee649d5d24085bf30";
  };

  pythonImportsCheck = [ "identify" ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
