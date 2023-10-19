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
  version = "8.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alphagov";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-pdBPjc2j0/PSk224r8un22pNQ9g1jMdhPn8XmoKp+ng=";
  };

  propagatedBuildInputs = [
    docopt
    pyjwt
    requests
  ];

  nativeCheckInputs = [
    freezegun
    mock
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  pythonImportsCheck = [
    "notifications_python_client"
  ];

  meta = with lib; {
    description = "Python client for the GOV.UK Notify API";
    homepage = "https://github.com/alphagov/notifications-python-client";
    changelog = "https://github.com/alphagov/notifications-python-client/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
