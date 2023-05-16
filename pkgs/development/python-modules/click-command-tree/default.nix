{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-command-tree";
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "whwright";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-uBp7462LutL8aFRFix3pbVYbSf1af6k0nW0J0HhJa1U=";
  };

=======
    hash = "sha256-vFOcn+ibyLZnhU3OQMtnHI04UqAY2/CCvhq4EEU4XFo=";
  };

  patches = [
    (fetchpatch {
      name = "remove-setup-downloading-flake8.patch";
      url = "https://github.com/whwright/click-command-tree/commit/1ecfcfa29bf01e1131e6ec712bd7338ac1283dc8.patch";
      hash = "sha256-u5jsNfEo1+XNlkVGPCM/rsDPnYko6cr2z2si9nq+sLA=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
