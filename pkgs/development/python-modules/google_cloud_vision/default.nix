{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-vision";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a067d9a661df2e9b356b2772051decfea1971f8d659c246412a165baf827c61";
  };

  checkInputs = [ mock ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  # pytest seems to pick up some file which overrides PYTHONPATH
  checkPhase = ''
    cd tests/unit
    python -m unittest discover
  '';

  meta = with stdenv.lib; {
    description = "Cloud Vision API API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
