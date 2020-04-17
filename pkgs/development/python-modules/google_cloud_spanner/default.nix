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
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ra1cim9kcs680yrhvfn5hjx8y1sccp3lw7id5j5pj53sshdng8h";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ grpcio-gcp grpc_google_iam_v1 google_api_core google_cloud_core ];

  # avoid importing local package
  checkPhase = ''
    rm -r google
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Spanner API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
