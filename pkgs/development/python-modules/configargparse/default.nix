{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pyyaml
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "configargparse";
<<<<<<< HEAD
  version = "1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.5.3";

  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-m77MY0IZ1AJkd4/Y7ltApvdF9y17Lgn92WZPYTCU9tA=";
  };

  passthru.optional-dependencies = {
    yaml = [
      pyyaml
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "configargparse"
  ];

  meta = with lib; {
    description = "A drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    changelog = "https://github.com/bw2/ConfigArgParse/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
=======
    rev = "v${version}";
    sha256 = "1dsai4bilkp2biy9swfdx2z0k4akw4lpvx12flmk00r80hzgbglz";
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "configargparse" ];

  meta = with lib; {
    description = "A drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    license = licenses.mit;
    maintainers = [ maintainers.willibutz ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
