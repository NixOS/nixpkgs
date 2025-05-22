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
  version = "8.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "facundobatista";
    repo = "logassert";
    tag = version;
    hash = "sha256-GKGNvOZde8Q6X5h+QC5936qTDWpcXYHuLXpsGuxw1Mw=";
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
