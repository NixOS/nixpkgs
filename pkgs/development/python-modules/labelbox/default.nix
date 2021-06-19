{ lib
, backoff
, backports-datetime-fromisoformat
, buildPythonPackage
, dataclasses
, fetchFromGitHub
, google-api-core
, jinja2
, ndjson
, pillow
, pydantic
, pytest-cases
, pytestCheckHook
, pythonOlder
, rasterio
, requests
, shapely
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "2.6.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    rev = "V${version}";
    sha256 = "1lkvc926i3c7isqhaja6k013qgla44cdhvkx76gpdyywq53i9mcb";
  };

  propagatedBuildInputs = [
    backoff
    backports-datetime-fromisoformat
    dataclasses
    google-api-core
    jinja2
    ndjson
    pillow
    pydantic
    rasterio
    requests
    shapely
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "pydantic==1.8" "pydantic>=1.8"
  '';

  checkInputs = [
    pytest-cases
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
  ];

  pythonImportsCheck = [ "labelbox" ];

  meta = with lib; {
    description = "Platform API for LabelBox";
    homepage = "https://github.com/Labelbox/labelbox-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
