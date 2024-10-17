{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  pytestCheckHook,
  python-utils,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-947qYsgJOL9T6pFPpbbJL0SPDqtWCeDlpzfd4DlAQzQ=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  dependencies = [
    numpy
    python-utils
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stl" ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    changelog = "https://github.com/wolph/numpy-stl/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
