{ buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, lib
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-artifact-registry";
  version = "1.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FuuxwOMV7IB1drn5hzX7p4BwJYQCUsgnZNVR+E6XKhM=";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "google.cloud.artifactregistry"
    "google.cloud.artifactregistry_v1"
    "google.cloud.artifactregistry_v1beta2"
  ];

  meta = with lib; {
    description = "Google Cloud Artifact Registry API client library";
    homepage = "https://github.com/googleapis/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
