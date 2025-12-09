{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "click-command-tree";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "whwright";
    repo = "click-command-tree";
    tag = version;
    hash = "sha256-oshAHCGe8p5BQ0W21bXSxrTCEFgIxZ6BmUEiWB1xAoI=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "click_command_tree" ];

  meta = with lib; {
    description = "Click plugin to show the command tree of your CLI";
    homepage = "https://github.com/whwright/click-command-tree";
    license = licenses.mit;
  };
}
