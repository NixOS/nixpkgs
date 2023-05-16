{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-option-group";
<<<<<<< HEAD
  version = "0.5.6";
=======
  version = "0.5.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-uR5rIZPPT6pRk/jJEy2rZciOXrHWVWN6BfGroQ3znas=";
=======
    hash = "sha256-ur7ycioZmgWMp4N+MURj1ggYMzs2eauteg1B5eLkSvc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "click_option_group"
  ];

  meta = with lib; {
    description = "Option groups missing in Click";
    longDescription = ''
      Option groups are convenient mechanism for logical structuring
      CLI, also it allows you to set the specific behavior and set the
      relationship among grouped options (mutually exclusive options
      for example). Moreover, argparse stdlib package contains this
      functionality out of the box.
    '';
    homepage = "https://github.com/click-contrib/click-option-group";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
