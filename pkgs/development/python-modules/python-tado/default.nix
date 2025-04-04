{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.18.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    tag = version;
    hash = "sha256-zGz3ySD+7zkHY/+IS2Kfrp9Y64It+rrEF7ImwbZG7ks=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # network access
    "test_interface_with_tado_api"
  ];

  disabledTestPaths = [
    # network access
    "tests/test_my_tado.py"
    "tests/test_my_zone.py"
  ];

  pythonImportsCheck = [ "PyTado" ];

  meta = with lib; {
    description = "Python binding for Tado web API";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    mainProgram = "pytado";
  };
}
