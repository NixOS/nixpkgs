{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-vision";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18e78b190c81d200ae4f6a46d4af57422d68b3b05b0540d5cd1806e3874142bf";
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
