{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.6.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TpPu5K3WSTtZpcUU2pjJObJE/OSg2Iec0/RmVi9LfVw=";
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
