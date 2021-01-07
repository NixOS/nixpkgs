{ stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-cloud-core
, google-api-core
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-resource-manager";
  version = "0.30.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1la643vkf6fm2gapz57cm92xzvmhzgpzv3bb6112yz1cizrvnxrm";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core ];

  checkInputs = [ mock pytestCheckHook ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud.resource_manager" ];

  meta = with stdenv.lib; {
    description = "Google Cloud Resource Manager API client library";
    homepage = "https://github.com/googleapis/python-resource-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
