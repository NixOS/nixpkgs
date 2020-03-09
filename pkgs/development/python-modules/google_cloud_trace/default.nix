{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-trace";
  version = "0.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a3fad1ae2b780dd5e6d5ddc626db722749405b7b66f3c2e5e87a9d29a4819c8";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Trace API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
