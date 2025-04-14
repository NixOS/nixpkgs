{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "queuelib";
  version = "1.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WCvGVRRIEQCwU5vWcdprNVuHiGnPx32Sxjt1/MnPjic=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "queuelib" ];

  meta = with lib; {
    description = "Collection of persistent (disk-based) queues for Python";
    homepage = "https://github.com/scrapy/queuelib";
    changelog = "https://github.com/scrapy/queuelib/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
