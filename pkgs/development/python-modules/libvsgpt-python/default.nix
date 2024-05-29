{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libvsgpt-python";
  version = "20240228";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6knIN5K0m0s5Wp7++tEuCBhhhu+Ego2OvRv87RAA3lQ=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvsgpt" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libvsgpt/releases/tag/${version}";
    description = "Python bindings module for libvsgpt";
    downloadPage = "https://github.com/libyal/libvsgpt/releases";
    homepage = "https://github.com/libyal/libvsgpt";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
