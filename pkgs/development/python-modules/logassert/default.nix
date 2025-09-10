{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  flake8,
  structlog,
}:

buildPythonPackage rec {
  pname = "logassert";
  version = "8.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "facundobatista";
    repo = "logassert";
    tag = version;
    hash = "sha256-dkBsR4FmiKjHzZc74Mt2cAffO7ZuIRnLOpFx60e9+so=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "logassert" ];

  nativeCheckInputs = [
    flake8
    pytestCheckHook
    structlog
  ];

  meta = {
    description = "Simple Log Assertion mechanism for Python unittests";
    homepage = "https://github.com/facundobatista/logassert";
    changelog = "https://github.com/facundobatista/logassert/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
