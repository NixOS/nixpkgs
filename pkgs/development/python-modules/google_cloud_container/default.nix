{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-container";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a89afcb1fe96bc9361c231c223c3bbe19fa3787caeb4697cd5778990e1077270";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Container Engine API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
