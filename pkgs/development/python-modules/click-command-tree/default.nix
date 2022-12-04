{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-command-tree";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "whwright";
    repo = pname;
    rev = version;
    hash = "sha256-vFOcn+ibyLZnhU3OQMtnHI04UqAY2/CCvhq4EEU4XFo=";
  };

  patches = [
    (fetchpatch {
      name = "remove-setup-downloading-flake8.patch";
      url = "https://github.com/whwright/click-command-tree/commit/1ecfcfa29bf01e1131e6ec712bd7338ac1283dc8.patch";
      hash = "sha256-u5jsNfEo1+XNlkVGPCM/rsDPnYko6cr2z2si9nq+sLA=";
    })
  ];

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
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
