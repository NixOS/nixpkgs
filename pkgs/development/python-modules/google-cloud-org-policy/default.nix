{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-org-policy";
  version = "1.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3BJDTwbIDhscHDR8rcjLQP/JYZrktcW+tcK9WFyV2X8=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  pythonImportsCheck = [ "google.cloud.orgpolicy" ];

  meta = with lib; {
    description = "Protobufs for Google Cloud Organization Policy";
    homepage = "https://github.com/googleapis/python-org-policy";
    changelog = "https://github.com/googleapis/python-org-policy/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
