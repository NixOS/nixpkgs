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
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-KJh9uJzVGYEEk1ed56ynKA/+dK9ouDB7L06xERjfjdc=";
  };

  propagatedBuildInputs = [
    karton-core
    mwdblib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "karton.mwdb_reporter" ];

  meta = with lib; {
    description = "Karton service that uploads analyzed artifacts and metadata to MWDB Core";
    mainProgram = "karton-mwdb-reporter";
    homepage = "https://github.com/CERT-Polska/karton-mwdb-reporter";
    changelog = "https://github.com/CERT-Polska/karton-mwdb-reporter/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
