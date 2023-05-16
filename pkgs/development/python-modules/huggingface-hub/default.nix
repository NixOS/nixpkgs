{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, filelock
, fsspec
<<<<<<< HEAD
=======
, importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, pyyaml
, requests
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
<<<<<<< HEAD
  version = "0.16.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "0.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-fWvEvYiaLiVGmDdfibIHJAsu7nUX+eaE0QGolS3LHO8=";
=======
    hash = "sha256-+BtXi+O+Ef4p4b+8FJCrZFsxX22ZYOPXylexFtsldnA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    filelock
    fsspec
    packaging
    pyyaml
    requests
    tqdm
    typing-extensions
<<<<<<< HEAD
=======
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Tests require network access.
  doCheck = false;

  pythonImportsCheck = [
    "huggingface_hub"
  ];

<<<<<<< HEAD
  meta = with lib; {
=======
   meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Download and publish models and other files on the huggingface.co hub";
    homepage = "https://github.com/huggingface/huggingface_hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
