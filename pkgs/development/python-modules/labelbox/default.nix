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
  version = "2.4.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b58604ee50c54a35994e54741d9071ecfebb6d6b9b2737604a95f29c4f23d6ec";
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
