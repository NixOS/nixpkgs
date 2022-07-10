{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, mwdblib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-mwdb-reporter";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2qG/8D6ZlUFJg+BB/QZ9ZMJpbsLei/7TRXd6bF40Fvg=";
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
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
