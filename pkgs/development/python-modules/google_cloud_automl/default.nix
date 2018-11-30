{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-automl";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "793d463f78d22a822196cb3e34b247fbdba07eeae15ceadb911f5ccecd843f87";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud AutoML API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
