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
  version = "0.31.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e0218abc438f2f43605db27189fa7a48c3ca3defc45054dac01835527058a4c";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  # ignore tests which require credentials or network
  checkPhase = ''
    rm -r google
    pytest tests/unit -k 'not client and not extra_headers'
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
