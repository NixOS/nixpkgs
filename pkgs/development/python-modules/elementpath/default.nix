{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "elementpath";
<<<<<<< HEAD
  version = "4.1.5";
=======
  version = "4.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-5K2xcnTo3/A6/pCxQn5qZqni7C64p/yNAWWJlhQeKe4=";
=======
    hash = "sha256-tu0WH/RwLVjGRX7vFlx7yLhmsE4Svg+qoWIoMbJSZjo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # avoid circular dependency with xmlschema which directly depends on this
  doCheck = false;

  pythonImportsCheck = [
    "elementpath"
  ];

  meta = with lib; {
    description = "XPath 1.0/2.0 parsers and selectors for ElementTree and lxml";
    homepage = "https://github.com/sissaschool/elementpath";
    changelog = "https://github.com/sissaschool/elementpath/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
