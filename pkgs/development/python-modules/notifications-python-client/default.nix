{ lib
, buildPythonPackage
, docopt
, fetchFromGitHub
, freezegun
, mock
, pyjwt
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "notifications-python-client";
  version = "6.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alphagov";
    repo = pname;
    rev = version;
    sha256 = "sha256-pfOTVgsfXJQ9GIGowra3RAwxCri76RgnA9iyWbjomCk=";
  };

  propagatedBuildInputs = [
    docopt
    pyjwt
    requests
  ];

  checkInputs = [
    freezegun
    mock
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  pythonImportsCheck = [
    "notifications_python_client"
  ];

  meta = with lib; {
    description = "Python client for the GOV.UK Notify API";
    homepage = "https://github.com/alphagov/notifications-python-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
