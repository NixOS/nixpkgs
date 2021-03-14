{ lib
, buildPythonPackage
, fetchPypi
, requests
, jinja2
, pillow
, rasterio
, shapely
, ndjson
, backoff
, google-api-core
, backports-datetime-fromisoformat
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "2.4.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5a631a94ac2059648a884bebf39f7ca1e689baef4a2497f9aa5ec598e24deb7";
  };

  propagatedBuildInputs = [
    jinja2 requests pillow rasterio shapely ndjson backoff
    google-api-core backports-datetime-fromisoformat
  ];

  # Test cases are not running on pypi or GitHub
  doCheck = false;
  pythonImportsCheck = [ "labelbox" ];

  meta = with lib; {
    homepage = "https://github.com/Labelbox/Labelbox";
    description = "Platform API for LabelBox";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
