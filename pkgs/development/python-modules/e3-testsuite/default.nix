{
  lib,
  buildPythonPackage,
  e3-core,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "e3-testsuite";
  version = "27.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "e3_testsuite";
    hash = "sha256-Vu43fIl2ZhmvtwPXPM3GIYojtgwv33zh/3tKNvlUw/Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ e3-core ];

  pythonImportsCheck = [ "e3" ];

  meta = {
    description = "Generic testsuite framework in Python";
    changelog = "https://github.com/AdaCore/e3-testsuite/releases/tag/${version}";
    homepage = "https://github.com/AdaCore/e3-testsuite/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ heijligen ];
    platforms = lib.platforms.linux;
  };
}
