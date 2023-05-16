{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-auth
, grpcio
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-core";
<<<<<<< HEAD
  version = "2.3.3";
=======
  version = "2.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-N7gCc8jX7uGugWs6IK5DWF6lBQbLDmDzz1vl+H8Tc8s=";
=======
    hash = "sha256-uVKe5wR/2NS/SiGC3mGRVCQN8X++YOrTmQeMGuFSr5o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    google-auth
    google-api-core
  ];

  passthru.optional-dependencies = {
    grpc = [
      grpcio
    ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.grpc;

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud"
  ];

  meta = with lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/googleapis/python-cloud-core";
    changelog = "https://github.com/googleapis/python-cloud-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
