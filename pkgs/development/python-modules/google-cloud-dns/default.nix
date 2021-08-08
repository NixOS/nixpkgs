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
  version = "0.32.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbb1c855524bd3f0f2a3b3db883af0d3f618befb976aa694d7e507dd68fc7a71";
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
