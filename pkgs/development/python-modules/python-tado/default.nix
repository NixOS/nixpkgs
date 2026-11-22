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

buildPythonPackage (finalAttrs: {
  pname = "python-tado";
  version = "0.18.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    tag = finalAttrs.version;
    hash = "sha256-jHPTu0/DYJXbSqiJXQzmiK6gmtJf88Y0BV1wj/X+qpc=";
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

  meta = {
    description = "Python binding for Tado web API";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jamiemagee ];
    mainProgram = "pytado";
  };
})
