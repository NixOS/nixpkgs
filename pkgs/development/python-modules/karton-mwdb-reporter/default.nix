{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, mwdblib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-mwdb-reporter";
  version = "unstable-2022-02-22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "1afa32251b4826eac4386596b4a20f295699faec";
    hash = "sha256-dbtIjWSNIRMccrGJspZMOBUD2EzuvW7xESlEwiOhKfQ=";
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
