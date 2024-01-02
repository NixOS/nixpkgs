{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-command-tree";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "whwright";
    repo = pname;
    rev = version;
    hash = "sha256-uBp7462LutL8aFRFix3pbVYbSf1af6k0nW0J0HhJa1U=";
  };

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [ "click_command_tree" ];

  meta = with lib; {
    description = "click plugin to show the command tree of your CLI";
    homepage = "https://github.com/whwright/click-command-tree";
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
