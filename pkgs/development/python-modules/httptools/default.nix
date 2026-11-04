{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1ITrt+Oj81l7D2RfvRuFYzZ0yoCMH1uhHCyvfGb1yLY=";
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
