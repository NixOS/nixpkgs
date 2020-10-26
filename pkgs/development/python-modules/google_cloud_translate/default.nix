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
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecdea3e176e80f606d08c4c7fd5acea6b3dd960f4b2e9a65951aaf800350a759";
  };

  # google_cloud_core[grpc] -> grpcio
  propagatedBuildInputs = [ google_api_core google_cloud_core grpcio ];

  checkInputs = [ pytest mock ];
  checkPhase = ''
    cd tests # prevent local google/__init__.py from getting loaded
    pytest unit -k 'not extra_headers'
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Google Cloud Translation API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
