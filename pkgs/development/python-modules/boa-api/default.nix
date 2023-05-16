{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "boa-api";
  version = "0.1.14";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "boalang";
    repo = "api-python";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    sha256 = "sha256-8tt68NLi5ewSKiHdu3gDawTBPylbDmB4zlUUqa7EQuY=";
  };

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "boaapi"
  ];
=======
    rev = "v${version}";
    sha256 = "sha256-8tt68NLi5ewSKiHdu3gDawTBPylbDmB4zlUUqa7EQuY=";
  };

  pythonImportsCheck = [ "boaapi" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    homepage = "https://github.com/boalang/api-python";
    description = "Python client API for communicating with Boa's (https://boa.cs.iastate.edu/) XML-RPC based services";
<<<<<<< HEAD
    changelog = "https://github.com/boalang/api-python/blob/${src.rev}/Changes.txt";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
