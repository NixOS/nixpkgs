{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-api-core
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uVKe5wR/2NS/SiGC3mGRVCQN8X++YOrTmQeMGuFSr5o=";
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
