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
  version = "8.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "facundobatista";
    repo = "logassert";
    tag = version;
    hash = "sha256-77oP7NE1fK1pA6baTHoSbfR7kR4URSmSpZSCgFO5Pb4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "logassert" ];

  nativeCheckInputs = [
    flake8
    pytestCheckHook
    structlog
  ];

  meta = {
    description = "A simple Log Assertion mechanism for Python unittests";
    homepage = "https://github.com/facundobatista/logassert";
    changelog = "https://github.com/facundobatista/logassert/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
