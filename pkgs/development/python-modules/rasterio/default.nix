{ buildPythonPackage, lib, fetchFromGitHub, pythonOlder
, cython, setuptools
, matplotlib, numpy, affine, attrs, boto3, cligj, click-plugins, snuggs, gdal
, pytest, pytestcov, hypothesis, shapely
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.2.6";
  disabled = pythonOlder "3.6";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "rasterio";
    rev = version;
    sha256 = "sha256-rf2qdUhbS4Z2+mvlN1RzZvlgTgjqiBoQzry4z5QLSUc=";
  };

  checkInputs = [ pytest pytestcov hypothesis shapely ];
  nativeBuildInputs = [ cython gdal ];
  propagatedBuildInputs = [ gdal matplotlib numpy attrs affine boto3 cligj click-plugins snuggs setuptools ];

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    license = licenses.bsd3;
    homepage = "https://rasterio.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };
}
