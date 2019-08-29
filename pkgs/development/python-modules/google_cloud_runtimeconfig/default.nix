{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-runtimeconfig";
  version = "0.28.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5b097a15fa9bb50442ccaf25fdb4622fdf09b8a873abf549c432d8fdc16c2f1";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
