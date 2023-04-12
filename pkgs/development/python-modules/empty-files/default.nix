{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "empty-files";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "EmptyFiles.Python";
    rev = "v${version}";
    hash = "sha256-K4rlVO1X1AWxYI3EqLsyQ5/Ist/jlwFrmOM4aMojtKU=";
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
