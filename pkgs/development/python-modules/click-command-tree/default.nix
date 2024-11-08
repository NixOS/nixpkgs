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
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-oshAHCGe8p5BQ0W21bXSxrTCEFgIxZ6BmUEiWB1xAoI=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "click_command_tree" ];

  meta = with lib; {
    description = "click plugin to show the command tree of your CLI";
    homepage = "https://github.com/whwright/click-command-tree";
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
