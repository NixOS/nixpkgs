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
  pname = "google-cloud-dns";
  version = "0.34.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RPpi7pPFHGxXIWBY2S0qkRa3E6SocanRajqDuZ4wwfk=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  preCheck = ''
    # don#t shadow python imports
    rm -r google
  '';

  disabledTests = [
    # requires credentials
    "test_quota"
  ];

  pythonImportsCheck = [
    "google.cloud.dns"
  ];

  meta = with lib; {
    description = "Google Cloud DNS API client library";
    homepage = "https://github.com/googleapis/python-dns";
    changelog = "https://github.com/googleapis/python-dns/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
