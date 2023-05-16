{ lib
, buildPythonPackage
, fastavro
, fetchPypi
, google-api-core
, google-auth
, google-cloud-bigquery
, pandas
, protobuf
, pyarrow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-storage";
<<<<<<< HEAD
  version = "2.22.0";
=======
  version = "2.19.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-9tjHs6ubV0xml3/O6dM24zStGjhDpyK+GRI2QOeAjqM=";
=======
    hash = "sha256-DZtfQqcD8yELSzrUWhgTkZH5NHQP3zYpsbIv2VrfC7o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    google-api-core
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    fastavro = [
      fastavro
    ];
    pandas = [
      pandas
    ];
    pyarrow = [
      pyarrow
    ];
  };

  nativeCheckInputs = [
    google-auth
    google-cloud-bigquery
    pytestCheckHook
  ];

  # Dependency loop with google-cloud-bigquery
  doCheck = false;

  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.bigquery_storage"
    "google.cloud.bigquery_storage_v1"
    "google.cloud.bigquery_storage_v1beta2"
  ];

  meta = with lib; {
    description = "BigQuery Storage API API client library";
    homepage = "https://github.com/googleapis/python-bigquery-storage";
    changelog = "https://github.com/googleapis/python-bigquery-storage/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
