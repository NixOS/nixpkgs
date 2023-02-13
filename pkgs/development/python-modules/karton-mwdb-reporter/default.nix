{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, mwdblib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-mwdb-reporter";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QVxczXT74Xt0AtCSDm4nhIK4qtHQ6bqmVNb/CALZSE4=";
  };

  propagatedBuildInputs = [
    karton-core
    mwdblib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "karton.mwdb_reporter"
  ];

  meta = with lib; {
    description = "Karton service that uploads analyzed artifacts and metadata to MWDB Core";
    homepage = "https://github.com/CERT-Polska/karton-mwdb-reporter";
    changelog = "https://github.com/CERT-Polska/karton-mwdb-reporter/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
