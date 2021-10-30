{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-cloud-runtimeconfig";
  version = "0.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc85e5de7cdb58a27561885021ee6fcf1d9f89e0f0db7c371bdca9c54788dd15";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core ];

  checkInputs = [ mock pytestCheckHook ];

  # Client tests require credentials
  disabledTests = [ "client_options" ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud.runtimeconfig" ];

  meta = with lib; {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = "https://pypi.org/project/google-cloud-runtimeconfig";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
