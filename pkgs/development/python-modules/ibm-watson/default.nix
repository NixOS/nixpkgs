{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, ibm-cloud-sdk-core
, pytest-rerunfailures
, pytestCheckHook
, python-dateutil
, python-dotenv
, pythonOlder
, requests
, responses
, websocket-client
=======
, responses
, pytestCheckHook
, python-dotenv
, pytest-rerunfailures
, requests
, python-dateutil
, websocket-client
, ibm-cloud-sdk-core
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "ibm-watson";
<<<<<<< HEAD
  version = "7.0.1";
=======
  version = "6.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "watson-developer-cloud";
    repo = "python-sdk";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-f/nf9WFiUNDQBkFNMV16EznCw0TN9L4fDIPQ/j4B1Sc=";
  };

  propagatedBuildInputs = [
    ibm-cloud-sdk-core
    python-dateutil
    requests
    websocket-client
  ];

  nativeCheckInputs = [
    pytest-rerunfailures
    pytestCheckHook
    python-dotenv
    responses
  ];

=======
    hash = "sha256-jvDkAwuDFgo7QlZ8N7TNVsY7+aXdIDc50uIIoO+5MLs=";
  };

  propagatedBuildInputs = [
    requests
    python-dateutil
    websocket-client
    ibm-cloud-sdk-core
  ];

  nativeCheckInputs = [
    responses
    pytestCheckHook
    python-dotenv
    pytest-rerunfailures
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace websocket-client==1.1.0 websocket-client>=1.1.0
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "ibm_watson"
  ];

  meta = with lib; {
    description = "Client library to use the IBM Watson Services";
    homepage = "https://github.com/watson-developer-cloud/python-sdk";
<<<<<<< HEAD
    changelog = "https://github.com/watson-developer-cloud/python-sdk/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}
