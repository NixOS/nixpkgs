{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  tokenize-rt,
}:

buildPythonPackage rec {
  pname = "add-trailing-comma";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "add-trailing-comma";
    tag = "v${version}";
    hash = "sha256-Ts04kjhGE0lgrHyT+EuJsVLIYU/842azG1ZUHTyFijc=";
  };

  build-system = [ setuptools ];

  dependencies = [ tokenize-rt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "add_trailing_comma" ];

  meta = {
    description = "Tool (and pre-commit hook) to automatically add trailing commas to calls and literals";
    homepage = "https://github.com/asottile/add-trailing-comma";
    changelog = "https://github.com/asottile/add-trailing-comma/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
    mainProgram = "add-trailing-comma";
  };
}
