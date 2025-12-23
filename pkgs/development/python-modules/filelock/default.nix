{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  hatch-vcs,
  hatchling,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.18.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rbyI6ruZ0v7IycGyKbFx8Yr6ZVQAFz3cZT1dAVAfufI=";
  };

  patches = [
    # Fix TOCTOU symlink vulnerability in lock file creation
    # https://github.com/tox-dev/filelock/commit/4724d7f8c3393ec1f048c93933e6e3e6ec321f0e
    (fetchpatch {
      url = "https://github.com/tox-dev/filelock/commit/4724d7f8c3393ec1f048c93933e6e3e6ec321f0e.patch";
      hash = "sha256-c46m/2f5KKhJ9zYlFauqZm64dCYU3Rivib6zIyt3EFM=";
    })
  ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "filelock" ];

  disabledTestPaths = [
    # Circular dependency with virtualenv
    "tests/test_virtualenv.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/py-filelock/releases/tag/${version}";
    description = "Platform independent file lock for Python";
    homepage = "https://github.com/benediktschmitt/py-filelock";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
