{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mermaid-py";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ouhammmourachid";
    repo = "mermaid-py";
    tag = "v${version}";
    hash = "sha256-QaIX8MLIKlVHGOU3xzvWNVEPoK6Lp3xkRni91PCik1U=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # These make real network requests to the mermaid.ink rendering API
    "tests/test_mermaid.py"
    "tests/test_malayalam.py"
  ];

  pythonImportsCheck = [ "mermaid" ];

  meta = {
    description = "Python interface for the mermaid-js library, simplified for diagram creation";
    homepage = "https://github.com/ouhammmourachid/mermaid-py";
    changelog = "https://github.com/ouhammmourachid/mermaid-py/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ giomf ];
  };
}
