{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, tkinter
}:

buildPythonPackage rec {
  pname = "guppy3";
<<<<<<< HEAD
  version = "3.1.3";
=======
  version = "3.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "zhuyifei1999";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-i3WqXlNnNhBVw9rdnxnzQISFkZHBpc/gqG+rxOWPiyc=";
=======
    hash = "sha256-f7YpaZ85PU/CSsDwSm2IJ/x2ZxzHoMOVbdbzT1i8y/w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ tkinter ];

  # Tests are starting a Tkinter GUI
  doCheck = false;
  pythonImportsCheck = [ "guppy" ];

  meta = with lib; {
    description = "Python Programming Environment & Heap analysis toolset";
    homepage = "https://zhuyifei1999.github.io/guppy3/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
