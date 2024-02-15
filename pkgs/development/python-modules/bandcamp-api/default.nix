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
  version = "0.2.3";

  format = "setuptools";

  src = fetchPypi {
    pname = "bandcamp_api";
    inherit version;
    hash = "sha256-7/WXMo7fCDMHATp4hEB8b7fNJWisUv06hbP+O878Phs=";
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
