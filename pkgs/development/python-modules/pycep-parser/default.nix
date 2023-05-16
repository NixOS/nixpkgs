{ lib
, assertpy
, buildPythonPackage
, fetchFromGitHub
, lark
, poetry-core
, pytestCheckHook
, pythonOlder
, regex
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pycep-parser";
<<<<<<< HEAD
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gruebel";
    repo = "pycep";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-OSdxdhGAZhl625VdIDHQ1aepQR5B0pCTLavfxer1tqc=";
=======
    hash = "sha256-ZKvFurD5DzByeqDJZdJHpkaUh00UoitCGYDh+TmF/Yc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    lark
    regex
    typing-extensions
  ];

  nativeCheckInputs = [
    assertpy
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'regex = "^2022.3.15"' 'regex = "*"'
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "pycep"
  ];

  meta = with lib; {
    description = "Python based Bicep parser";
    homepage = "https://github.com/gruebel/pycep";
<<<<<<< HEAD
    changelog = "https://github.com/gruebel/pycep/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
