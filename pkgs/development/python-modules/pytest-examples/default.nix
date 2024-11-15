{
  lib,
  black,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  hatchling,
  pytest,
  pytestCheckHook,
  pythonOlder,
  ruff,
}:

buildPythonPackage rec {
  pname = "pytest-examples";
  version = "0.0.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pytest-examples";
    rev = "refs/tags/v${version}";
    hash = "sha256-R0gSWQEGMkJhkeXImyris2wzqjJ0hC3zO0voEdhWLoY=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/pydantic/pytest-examples/pull/37.patch";
      hash = "sha256-SISZl2mTDrazQjlwtS9c/dkfY05VKapkdvCmfB0/cQU=";
    })
    (fetchpatch2 {
      url = "https://github.com/pydantic/pytest-examples/pull/41.patch";
      hash = "sha256-E8j8clAUZEJo0ZXBS8VaaoT4krEVdfPIaVC94kFKO0c=";
    })
  ];

  build-system = [
    hatchling
  ];

  buildInputs = [ pytest ruff ];

  dependencies = [ black ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_examples" ];

  meta = {
    description = "Pytest plugin for testing examples in docstrings and markdown files";
    homepage = "https://github.com/pydantic/pytest-examples";
    changelog = "https://github.com/pydantic/pytest-examples/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
