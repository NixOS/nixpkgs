{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q9clVpdPjnx0olllWSSnF6I2WyNsiCw/b4pF/pRwOsk=";
  };

  # Tests are not included in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "httptools" ];

  meta = {
    description = "Collection of framework independent HTTP protocol utils";
    homepage = "https://github.com/MagicStack/httptools";
    changelog = "https://github.com/MagicStack/httptools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
