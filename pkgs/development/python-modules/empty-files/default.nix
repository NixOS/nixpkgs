{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "empty-files";
  version = "0.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "EmptyFiles.Python";
    rev = "refs/tags/v${version}";
    hash = "sha256-P/woyAN9cYdxryX1iM36C53c9dL6lo4eoTzBWT2cd3A=";
  };

  propagatedBuildInputs = [ requests ];

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
