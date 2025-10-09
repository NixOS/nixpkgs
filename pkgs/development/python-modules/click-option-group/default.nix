{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "click-option-group";
  version = "0.5.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-option-group";
    tag = "v${version}";
    hash = "sha256-VTJsyaJBKU+BqjQWisQOTZikGGkPaafmJ778UUOeyPs=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "click_option_group" ];

  meta = with lib; {
    description = "Option groups missing in Click";
    longDescription = ''
      Option groups are convenient mechanism for logical structuring
      CLI, also it allows you to set the specific behavior and set the
      relationship among grouped options (mutually exclusive options
      for example). Moreover, argparse stdlib package contains this
      functionality out of the box.
    '';
    homepage = "https://github.com/click-contrib/click-option-group/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
