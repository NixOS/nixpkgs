{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-runtimeconfig";
  version = "0.33.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4sv5wua03gLd9YqwdD8P/VaKv4LcacB42fK5hUAt2vQ=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  # Client tests require credentials
  disabledTests = [
    "client_options"
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.runtimeconfig"
  ];

  meta = with lib; {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = "https://github.com/googleapis/python-runtimeconfig";
    changelog = "https://github.com/googleapis/python-runtimeconfig/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
