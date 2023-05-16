{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "empty-files";
<<<<<<< HEAD
  version = "0.0.9";
=======
  version = "0.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "EmptyFiles.Python";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-P/woyAN9cYdxryX1iM36C53c9dL6lo4eoTzBWT2cd3A=";
=======
    rev = "v${version}";
    hash = "sha256-K4rlVO1X1AWxYI3EqLsyQ5/Ist/jlwFrmOM4aMojtKU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  # cyclic dependency with approvaltests
  doCheck = false;

  pythonImportsCheck = [ "empty_files" ];

  meta = with lib; {
    description = "Null Object pattern for files";
    homepage = "https://github.com/approvals/EmptyFiles.Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
