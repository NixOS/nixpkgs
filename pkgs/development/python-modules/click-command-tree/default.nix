{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-command-tree";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "whwright";
    repo = "click-command-tree";
    tag = finalAttrs.version;
    hash = "sha256-oshAHCGe8p5BQ0W21bXSxrTCEFgIxZ6BmUEiWB1xAoI=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "click_command_tree" ];

  meta = {
    description = "Click plugin to show the command tree of your CLI";
    homepage = "https://github.com/whwright/click-command-tree";
    license = lib.licenses.mit;
  };
})
