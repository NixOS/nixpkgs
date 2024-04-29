{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libevt-python";
  version = "20240421";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z2kZ+rl7IEZpANJ4Vc9JiSMz5PLuQ5ySDoX6JgtZ1xU=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyevt" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libevt/releases/releases/tag/${version}";
    description = "Python bindings module for libevt";
    homepage = "https://github.com/libyal/libevt";
    downloadPage = "https://github.com/libyal/libevt/releases";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
