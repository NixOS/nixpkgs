{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests-mock
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "fitbit";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "orcasgit";
    repo = "python-fitbit";
    rev = version;
    hash = "sha256-1u3h47lRBrJ7EUWBl5+RLGW4KHHqXqqrXbboZdy7VPA=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests-oauthlib
  ];

  nativeCheckInputs = [
    freezegun
    mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "fitbit"
  ];

  meta = with lib; {
    description = "Fitbit API Python Client Implementation";
    homepage = "https://github.com/orcasgit/python-fitbit";
    license = licenses.asl20;
    maintainers = with maintainers; [ delroth ];
  };
}
