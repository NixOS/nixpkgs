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
  version = "0.2.2";

  format = "setuptools";

  src = fetchPypi {
    pname = "bandcamp_api";
    inherit version;
    hash = "sha256-v/iACVcBFC/3x4v7Q/1p+aHGhfw3AQ43eU3sKz5BskI=";
  };

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
