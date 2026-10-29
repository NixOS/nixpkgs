{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  typing-extensions,

  # checks
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flexparser";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "flexparser";
    rev = finalAttrs.version;
    hash = "sha256-0Ocp4GsrnzkpSqnP+AK5OxJ3KyUf5Uc6CegDXpRYRqo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flexparser" ];

  meta = {
    description = "Parsing made fun ... using typing";
    homepage = "https://github.com/hgrecco/flexparser";
    changelog = "https://github.com/hgrecco/flexparser/blob/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
