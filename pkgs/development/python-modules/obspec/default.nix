{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  # build system
  hatchling,

  # dependencies
  typing-extensions,

  # test dependencies
  pytest,
  pytest-mypy-plugins,
  mypy,
}:
buildPythonPackage (finalAttrs: {
  pname = "obspec";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "obspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zO2T189WUl1HJkBLrGpArS5NoFNpEchWfjJQJEME5W8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "obspec" ];

  nativeCheckInputs = [
    pytestCheckHook
    mypy
  ];

  checkInputs = [
    pytest-mypy-plugins
  ];

  meta = {
    description = "Object storage interface definitions for Python";
    homepage = "http://developmentseed.org/obspec/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ autra ];
  };
})
