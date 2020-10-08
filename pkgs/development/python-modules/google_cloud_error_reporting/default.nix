{ stdenv
, buildPythonPackage
, fetchPypi
, google_cloud_logging
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "0.34.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34edd11601b17c87a89c2e1cefdc27d975e1e9243a88ba3c0c48bfe6a05c404f";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_cloud_logging ];

  checkPhase = ''
    rm -r google
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
