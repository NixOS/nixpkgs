{ lib
, buildPythonPackage
, fetchPypi
, requests
, jinja2
, pillow
, dataclasses
, pythonOlder
, rasterio
, shapely
, ndjson
, backoff
, pydantic
, google-api-core
, backports-datetime-fromisoformat
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "2.5.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-L1KjP8Yzx9adTK84+Nf9JnirT4p3D3lwulWw6W1L/88=";
  };

  propagatedBuildInputs = [
    jinja2 requests pillow rasterio shapely ndjson backoff
    google-api-core backports-datetime-fromisoformat pydantic
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "pydantic==1.8" "pydantic>=1.8"
  '';

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
