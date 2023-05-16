{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-testutils
, grpc-google-iam-v1
, grpcio
, grpcio-status
, libcst
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-pubsub";
<<<<<<< HEAD
  version = "2.18.4";
=======
  version = "2.16.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Muth/UwdxshC9ZTWnZr6gFROOzJ6pkChZOtvsCAery0=";
=======
    hash = "sha256-MeJxvnVe1xQ64M3+0FBvr0DXUEtG+lyLW6tLki9sPTs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    grpcio
    grpcio-status
    libcst
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    libcst = [
      libcst
    ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTestPaths = [
    # Tests in pubsub_v1 attempt to contact pubsub.googleapis.com
    "tests/unit/pubsub_v1"
  ];

  pythonImportsCheck = [
    "google.cloud.pubsub"
  ];

  meta = with lib; {
    description = "Google Cloud Pub/Sub API client library";
    homepage = "https://github.com/googleapis/python-pubsub";
    changelog = "https://github.com/googleapis/python-pubsub/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
