{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "mistune";
    tag = "v${version}";
    hash = "sha256-gXCFBe58Ij6CiwTddsI4tkPsGBR2z9D8dnxlvTXGSMw=";
  };

  dependencies = lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mistune" ];

  meta = {
    changelog = "https://github.com/lepture/mistune/blob/${src.tag}/docs/changes.rst";
    description = "Sane Markdown parser with useful plugins and renderers";
    homepage = "https://github.com/lepture/mistune";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
