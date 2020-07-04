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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02wlqlrxk0x6a9wifcly2pr84r6k8i97ws0prx21379fss39gf2a";
  };

  # google_cloud_core[grpc] -> grpcio
  propagatedBuildInputs = [ google_api_core google_cloud_core grpcio ];

  checkInputs = [ pytest mock ];
  checkPhase = ''
    cd tests # prevent local google/__init__.py from getting loaded
    pytest unit -k 'not extra_headers'
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Translation API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
