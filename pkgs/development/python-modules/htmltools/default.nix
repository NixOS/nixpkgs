{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, packaging
, typing-extensions
, pytestCheckHook
, syrupy
}:

buildPythonPackage rec {
  pname = "htmltools";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-htmltools";
    rev = "refs/tags/v${version}";
    hash = "sha256-+BSbJdWmqoEQGEJWBgoTVe4bbvlGJiMyfvvj0lAy9ZA=";
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
