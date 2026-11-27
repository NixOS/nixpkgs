{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  setuptools,
  pylint,
  pytest,
  pytestCheckHook,
  toml,
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.21.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iHZLjh1c+hiAkkjgzML8BQNfCMNfCwIi3c/qHDxOVT4=";
  };

  patches = [
    # Use pathlib.Path in plugin hooks for pytest 8.1+ compatibility.
    (fetchpatch2 {
      url = "https://github.com/carsongee/pytest-pylint/commit/62457e8013df106116fb2a62c7c44870103ff393.patch?full_index=1";
      hash = "sha256-EnlHEe5uZkvrWO8B33xkQ3LCQ7Bj5/oLES//NP8vkwE=";
    })
    # Handle test output difference in pytest 9.
    # https://github.com/carsongee/pytest-pylint/pull/196
    ./pytest-9.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [
    pylint
    toml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_pylint" ];

  meta = {
    description = "Pytest plugin to check source code with pylint";
    homepage = "https://github.com/carsongee/pytest-pylint";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
}
