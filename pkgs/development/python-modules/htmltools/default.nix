{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  packaging,
  typing-extensions,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "htmltools";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-htmltools";
    rev = "refs/tags/v${version}";
    hash = "sha256-ugtDYs5YaVo7Yy9EodyRrypHQUjmOIPpsyhwNnZkiko=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    packaging
    typing-extensions
  ];

  pythonImportsCheck = [ "htmltools" ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  meta = {
    description = "Tools for HTML generation and output";
    homepage = "https://github.com/posit-dev/py-htmltools";
    changelog = "https://github.com/posit-dev/py-htmltools/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
