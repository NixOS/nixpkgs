{ buildPythonPackage, lib, fetchFromGitHub, isPy3k
, cython, setuptools
, numpy, affine, attrs, cligj, click-plugins, snuggs, gdal
, pytest, pythonOlder, packaging, hypothesis, boto3
, certifi, shapely
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.2.10";
  disabled = pythonOlder "3.6";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "rasterio";
    rev = version;
    sha256 = "sha256-xVGwQfQvxsqYihUYXENJAz9Qp9xBkhsGc/RheRTJxgo=";
  };

  checkInputs = [ boto3 pytest packaging hypothesis shapely ];
  nativeBuildInputs = [ cython gdal ];
  propagatedBuildInputs = [ certifi gdal numpy attrs affine cligj click-plugins snuggs setuptools ];

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    license = licenses.bsd3;
    homepage = "https://rasterio.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };
}
