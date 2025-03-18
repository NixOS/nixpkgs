{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "click-option-group";
  version = "0.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-option-group";
    tag = "v${version}";
    hash = "sha256-uR5rIZPPT6pRk/jJEy2rZciOXrHWVWN6BfGroQ3znas=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError (assert result.exception)
    "test_missing_group_decl_first_api"
  ];

  pythonImportsCheck = [ "click_option_group" ];

  meta = {
    description = "Option groups missing in Click";
    longDescription = ''
      Option groups are convenient mechanism for logical structuring
      CLI, also it allows you to set the specific behavior and set the
      relationship among grouped options (mutually exclusive options
      for example). Moreover, argparse stdlib package contains this
      functionality out of the box.
    '';
    homepage = "https://github.com/click-contrib/click-option-group";
    changelog = "https://github.com/click-contrib/click-option-group/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
