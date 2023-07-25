{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "empty-files";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "EmptyFiles.Python";
    rev = "refs/tags/v${version}";
    hash = "sha256-sXatMH2QEGxzDGszAoFXUoPzB00rYaQIasz93vsfyz8=";
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
