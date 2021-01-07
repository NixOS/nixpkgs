{ stdenv
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-cloud-runtimeconfig";
  version = "0.32.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bd8hlp0ssi20ds4gknbxai8mih6xiz8b60ab7p0ngpdqp1kw52p";
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

  meta = with stdenv.lib; {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = "https://pypi.org/project/google-cloud-runtimeconfig";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
