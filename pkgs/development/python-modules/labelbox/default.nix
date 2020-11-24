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
, google_api_core
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "2.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2be6c03dafce0a786cfab5d120196efccaf300cab5aee4d2fdad644b7bee1aef";
  };

  propagatedBuildInputs = [
    jinja2 requests pillow rasterio shapely ndjson backoff
    google_api_core
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
