{
  lib,
  astral,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  num2words,
  pdm-backend,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "hdate";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "py-libhdate";
    repo = "py-libhdate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3MOxDVrEMuMfk/fCCo6IItqR1DMr/0KN7L4hYjMYCGM=";
  };

  pythonRelaxDeps = [
    "astral"
  ];

  build-system = [
    pdm-backend
  ];

  dependencies = [
    num2words
  ];

  optional-dependencies = {
    astral = [ astral ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    syrupy
  ];

  pytestFlags = [ "--snapshot-warn-unused" ];

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "hdate" ];

  meta = {
    description = "Python module for Jewish/Hebrew date and Zmanim";
    homepage = "https://github.com/py-libhdate/py-libhdate";
    changelog = "https://github.com/py-libhdate/py-libhdate/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
