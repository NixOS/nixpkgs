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
  version = "0.32.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UoWu+Y/bmmkefFR4nnxJPFFnS253/myWcXKujq27oCY=";
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
