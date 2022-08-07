{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-dns";
  version = "0.34.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RPpi7pPFHGxXIWBY2S0qkRa3E6SocanRajqDuZ4wwfk=";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core ];

  checkInputs = [ mock pytestCheckHook ];

  preCheck = ''
    # don#t shadow python imports
    rm -r google
  '';

  disabledTests = [
    # requires credentials
    "test_quota"
  ];

  pythonImportsCheck = [ "google.cloud.dns" ];

  meta = with lib; {
    description = "Google Cloud DNS API client library";
    homepage = "https://github.com/googleapis/python-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
