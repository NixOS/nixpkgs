{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "queuelib";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sS/qef2MHdI+ISsfPbWAA7dzlJgB1PTm802IJGfUoZI=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "queuelib" ];

  meta = {
    description = "Collection of persistent (disk-based) queues for Python";
    homepage = "https://github.com/scrapy/queuelib";
    changelog = "https://github.com/scrapy/queuelib/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
