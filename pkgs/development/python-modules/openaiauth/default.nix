{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
}:

buildPythonPackage rec {
  pname = "openaiauth";
<<<<<<< HEAD
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit version;
    pname = "OpenAIAuth";
<<<<<<< HEAD
    hash = "sha256-wmVR+cN/uJ75l62uzmHqpvEcnjzi6CU0kQ2e/5LxkBw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Module has no tests
=======
    hash = "sha256-SaiTqs2HVv5ajUkrLJv24ed1+iJg5HqsCNe0IETkA00=";
  };

  propagatedBuildInputs = [ requests ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  pythonImportsCheck = [
    "OpenAIAuth"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Library for authenticating with the OpenAI API";
    homepage = "https://github.com/acheong08/OpenAIAuth";
    changelog = "https://github.com/acheong08/OpenAIAuth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
=======
    description = "A Python library for authenticating with the OpenAI API";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/acheong08/OpenAIAuth";
    changelog = "https://github.com/acheong08/OpenAIAuth/releases/tag/${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
