{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, grpcio
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-translate";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nfc628nr2k6kd3q9qpgwz7c12l0191rv5x4pvca8q82jl96gip5";
  };

  # google_cloud_core[grpc] -> grpcio
  propagatedBuildInputs = [ google_api_core google_cloud_core grpcio ];

  checkInputs = [ pytest mock ];
  checkPhase = ''
    cd tests # prevent local google/__init__.py from getting loaded
    pytest unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Translation API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
