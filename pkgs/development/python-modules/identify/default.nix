{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.5.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de7129142a5c86d75a52b96f394d94d96d497881d2aaf8eafe320cdbe8ac4bcc";
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
