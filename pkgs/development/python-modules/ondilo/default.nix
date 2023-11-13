{ lib
, buildPythonPackage
, fetchFromGitHub
, oauthlib
, pythonOlder
, requests
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "ondilo";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "JeromeHXP";
    repo = pname;
    rev = version;
    hash = "sha256-MI6K+41I/IVi+GRBdmRIHbljULDFLAwpo3W8tdxCOBM=";
  };

  propagatedBuildInputs = [
    oauthlib
    requests
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ondilo"
  ];

  meta = with lib; {
    description = "Python package to access Ondilo ICO APIs";
    homepage = "https://github.com/JeromeHXP/ondilo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
