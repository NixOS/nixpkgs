{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google_cloud_core, google_api_core, mock, pytest }:

buildPythonPackage rec {
  pname = "google-cloud-resource-manager";
  version = "0.30.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3577bbf38f2c7c2f42306b8dfdeffbb0eedf45aaec947fd513d51937f72046d1";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [ mock pytestCheckHook ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  # api_url test broken, fix not yet released
  # https://github.com/googleapis/python-resource-manager/pull/31
  disabledTests =
    [ "api_url_no_extra_query_param" "api_url_w_custom_endpoint" ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Resource Manager API client library";
    homepage = "https://github.com/googleapis/python-resource-manager";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
