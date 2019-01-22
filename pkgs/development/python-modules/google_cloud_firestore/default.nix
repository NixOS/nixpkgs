{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-firestore";
  version = "0.30.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e82481ff396e166f530c097a74670efab93466a70a6a2676081a3f30ef74b7f";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  # tests were not included with release
  # See issue https://github.com/googleapis/google-cloud-python/issues/6380
  doCheck = false;

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Firestore API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
