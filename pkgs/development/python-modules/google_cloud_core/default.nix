{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytestCheckHook, python
, google_api_core, grpcio, mock }:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "103bgv9d6fw01vbbdx0qxa5gqdzxqmiwlpdvibmqxkhb3c6bgbr1";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [ google_api_core grpcio ];
  checkInputs = [ google_api_core mock pytestCheckHook ];

  pythonImportsCheck = [ "google.cloud" ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  meta = with stdenv.lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/googleapis/python-cloud-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
