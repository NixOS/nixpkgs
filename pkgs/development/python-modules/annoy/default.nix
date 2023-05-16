{ lib
, buildPythonPackage
, fetchPypi
, h5py
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "annoy";
<<<<<<< HEAD
  version = "1.17.3";
=======
  version = "1.17.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-nL/r7+Cl+EPropxr5MhNYB9PQa1N7QSG8biMOwdznBU=";
=======
    hash = "sha256-5nv7uDfRMG2kVVyIOGDHshXLMqhk5AAiKS1YR60foLs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    h5py
  ];

  nativeCheckInputs = [
    nose
  ];

  pythonImportsCheck = [
    "annoy"
  ];

  meta = with lib; {
    description = "Approximate Nearest Neighbors in C++/Python optimized for memory usage and loading/saving to disk";
    homepage = "https://github.com/spotify/annoy";
    changelog = "https://github.com/spotify/annoy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
