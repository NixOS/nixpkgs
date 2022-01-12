{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-api-core
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "476d1f71ab78089e0638e0aaf34bfdc99bab4fce8f4170ba6321a5243d13c5c7";
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
