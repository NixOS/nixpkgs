{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  tox,
}:
buildPythonPackage rec {
  pname = "abnf";
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "declaresub";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DyVJQ682cGPAzwSGAFTh9gWGwnyDiaq6j7VhD6KSj/o=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tox
  ];

  meta = {
    description = "Python parser generator for ABNF grammars ";
    homepage = "https://github.com/declaresub/abnf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ feyorsh ];
  };
}
