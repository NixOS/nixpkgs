{ lib
, buildPythonPackage
, fetchFromGitHub
, rns
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lxmf";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-6ZnYI6GlFkMjBLsZhhFg8G9j3I/DfjLAnKsRFEua7uU=";
=======
    hash = "sha256-uz3IUUL5rdYwUsBNdHB+K/ZaCCnUE5EThFConVl8YgM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    rns
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "LXMF"
  ];

  meta = with lib; {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
