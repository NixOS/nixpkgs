{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
<<<<<<< HEAD
  version = "1.8.2";
=======
  version = "1.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-SJpjS72keOf9QF1imsWLbgMSzxCDloO4tuc4vUy8ZBk=";
=======
    hash = "sha256-JVXRVq7yrRLj15ZMKVCBvCsrRP8KcRj9XNvfeH0rXVc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.orgpolicy"
  ];

  meta = with lib; {
    description = "Protobufs for Google Cloud Organization Policy";
    homepage = "https://github.com/googleapis/python-org-policy";
    changelog = "https://github.com/googleapis/python-org-policy/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ austinbutler ];
=======
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
