{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, python
, google-api-core
, grpcio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35a1f5f02a86e0fa2e28c669f0db4a76d928671a28fbbbb493ab59ba9d1cb9a9";
  };

  propagatedBuildInputs = [ google-api-core ];

  checkInputs = [ mock pytestCheckHook ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud" ];

  meta = with lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/googleapis/python-cloud-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
