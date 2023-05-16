{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, protobuf
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-os-config";
<<<<<<< HEAD
  version = "1.15.2";
=======
  version = "1.15.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-WgrqxnVsbA0ppvfcqxW+kA8vjn71bMU9qAyZraqYt8g=";
=======
    hash = "sha256-OaF1pzRY5k5SvXNCxTviP/2lhC7Up+oXaQB14f2tGj8=";
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

  pythonImportsCheck = [
    "google.cloud.osconfig"
  ];

  disabledTests = [
    "test_patch_deployment"
    "test_patch_job"
  ];

  meta = with lib; {
    description = "Google Cloud OS Config API client library";
    homepage = "https://github.com/googleapis/python-os-config";
    changelog = "https://github.com/googleapis/python-os-config/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
