{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  };
}
