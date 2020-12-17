{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google_api_core, google_cloud_core, mock }:

buildPythonPackage rec {
  pname = "google-cloud-runtimeconfig";
  version = "0.32.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57143ec3c5ed3e0bee590a98857eec06c68aa2eacbce477403226a0d2e85a8ad";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [ mock pytestCheckHook ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  # api_url test broken, fix not yet released
  # https://github.com/googleapis/python-resource-manager/pull/31
  # Client tests require credentials
  disabledTests = [ "build_api_url_w_custom_endpoint" "client_options" ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = "https://pypi.org/project/google-cloud-runtimeconfig";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
