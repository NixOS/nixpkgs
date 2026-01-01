{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  mwdblib,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "karton-mwdb-reporter";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-mwdb-reporter";
    tag = "v${version}";
    hash = "sha256-KJh9uJzVGYEEk1ed56ynKA/+dK9ouDB7L06xERjfjdc=";
  };

  propagatedBuildInputs = [
    karton-core
    mwdblib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "karton.mwdb_reporter" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Karton service that uploads analyzed artifacts and metadata to MWDB Core";
    mainProgram = "karton-mwdb-reporter";
    homepage = "https://github.com/CERT-Polska/karton-mwdb-reporter";
    changelog = "https://github.com/CERT-Polska/karton-mwdb-reporter/releases/tag/v${version}";
<<<<<<< HEAD
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
=======
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
