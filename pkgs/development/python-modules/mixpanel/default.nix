
{ buildPythonPackage
, fetchFromGitHub
, lib

# Python Dependencies
, six
, urllib3
, requests

# tests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "mixpanel";
  version = "4.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mixpanel";
    repo = "mixpanel-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-jV2NLEc23uaI5Q7ZXDwGaZV9iAKQLMAETRTw8epZwQA=";
  };

  propagatedBuildInputs = [
    requests
    six
    urllib3
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  meta = with lib; {
    homepage = "https://github.com/mixpanel/mixpanel-python";
    description = "Official Mixpanel Python library";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
