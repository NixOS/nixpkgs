{ lib
, buildPythonPackage
, fetchPypi
, beautifulsoup4
, demjson3
, html5lib
, lxml
, requests
}:

buildPythonPackage rec {
  pname = "bandcamp-api";
  version = "0.1.15";

  format = "setuptools";

  src = fetchPypi {
    pname = "bandcamp_api";
    inherit version;
    hash = "sha256-4pnUiAsOLX1BBQjOhUkjSyHnGyQ3rx3JAFFYgEMLpG4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace bs4 beautifulsoup4
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    demjson3
    html5lib
    lxml
    requests
  ];

  pythonImportsCheck = [ "bandcamp_api" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Obtains information from bandcamp.com";
    homepage = "https://github.com/RustyRin/bandcamp-api";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
