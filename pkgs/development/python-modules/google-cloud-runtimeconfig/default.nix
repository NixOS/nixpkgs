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
  version = "0.32.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f333aa1f6a47cb5a38f3416c4ac9a4bbeaceeb1f3f2381fef9553c9fb665cc7";
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
