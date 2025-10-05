{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tokenize-rt,
}:

buildPythonPackage rec {
  pname = "add-trailing-comma";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "add-trailing-comma";
    tag = "v${version}";
    hash = "sha256-b9EHlx149NUAo9UHDZLE3BwSJY5WpxsUYi1mqz7rnHA=";
  };

  build-system = [ setuptools ];

  dependencies = [ tokenize-rt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "add_trailing_comma" ];

  meta = with lib; {
    description = "Tool (and pre-commit hook) to automatically add trailing commas to calls and literals";
    homepage = "https://github.com/asottile/add-trailing-comma";
    changelog = "https://github.com/asottile/add-trailing-comma/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
    mainProgram = "add-trailing-comma";
  };
}
