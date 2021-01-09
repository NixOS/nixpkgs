{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, python
, google-api-core
, grpcio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01liq4nrd2g3ingg8v0ly4c86db8agnr9h1fiz219c7fz0as0xqj";
  };

  propagatedBuildInputs = [ google-api-core ];

  checkInputs = [ mock pytestCheckHook ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud" ];

  meta = with stdenv.lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/googleapis/python-cloud-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
