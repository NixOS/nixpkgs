{ stdenv
, buildPythonPackage
, fetchPypi
, grpc_google_iam_v1
, grpcio-gcp
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-spanner";
  version = "1.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3240a04eaa6496e9d8bf4929f4ff04de1652621fd49555eb83b743c48ed9ca04";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ grpcio-gcp grpc_google_iam_v1 google_api_core google_cloud_core ];

  # avoid importing local package
  checkPhase = ''
    rm -r google
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Cloud Spanner API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
