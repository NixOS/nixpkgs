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
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "numpy_stl";
    inherit version;
    hash = "sha256-WiDD95zdqgq8akuZ9Uhqzu1PiBUvKbGaV6zIROGD/U0=";
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
