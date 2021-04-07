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
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f2cbc5d4869d8acde865ad519fc1cc85338247cd7cf534334f988a040679219";
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
