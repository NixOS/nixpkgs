{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-vision";
  version = "0.41.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd7adcfd8f1bddc19797b25ba3287a4f0cf42e208f330fffb7f1cd125e4d6cd3";
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
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
