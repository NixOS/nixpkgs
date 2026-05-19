{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-integration";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbwdevries";
    repo = "pytest-integration";
    tag = "v${version}";
    hash = "sha256-Ziy+GEfljYDccx3mm63p7rhDUQVDXLbk7DxUW3npjiE=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "pytest_integration" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests need to discover the mock `package` module located under `example/`
  preCheck = ''
    pushd example
  '';

  postCheck = ''
    popd
  '';

  meta = {
    description = "Organizing test by unit test, quick integration or slow integration";
    homepage = "https://github.com/jbwdevries/pytest-integration";
    changelog = "https://github.com/jbwdevries/pytest-integration/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
