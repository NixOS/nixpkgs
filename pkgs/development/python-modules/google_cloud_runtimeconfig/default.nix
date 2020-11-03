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
  version = "0.32.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d125c01817d5bef2b644095b044d22b03b9d8d4591088cadd8e97851f7a150a";
  };

  checkInputs = [ pytest mock ];
  requiredPythonModules = [ google_api_core google_cloud_core ];

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
