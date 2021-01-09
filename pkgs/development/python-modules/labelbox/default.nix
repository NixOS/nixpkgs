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
  version = "2.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "488fb0b2233738c3bba3d3bf67b941f105553b7286cca3099ac0120dd247bd84";
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
