{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libsigscan-python";
  version = "20240219";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iSsEQyHrBMcr+p+Vyei9J05+PXCWAvsR6G2EMVTXNGU=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pysigscan" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libsigscan/releases/tag/${version}";
    description = "Python bindings module for libsigscan";
    downloadPage = "https://github.com/libyal/libsigscan/releases";
    homepage = "https://github.com/libyal/libsigscan";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
