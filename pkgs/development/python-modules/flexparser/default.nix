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
  pytest-mpl,
  pytest-subtests,
}:

buildPythonPackage rec {
  pname = "flexparser";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "flexparser";
    rev = version;
    hash = "sha256-0Ocp4GsrnzkpSqnP+AK5OxJ3KyUf5Uc6CegDXpRYRqo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    pytest-subtests
  ];

  pythonImportsCheck = [ "flexparser" ];

  meta = {
    description = "Parsing made fun ... using typing";
    homepage = "https://github.com/hgrecco/flexparser";
    changelog = "https://github.com/hgrecco/flexparser/blob/${src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
