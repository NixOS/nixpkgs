{ buildPythonPackage, lib, fetchFromGitHub
, cython
, numpy, affine, attrs, cligj, click-plugins, snuggs, gdal
, pytest, pytestcov, packaging, hypothesis, boto3
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.0.22";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "rasterio";
    rev = version;
    sha256 = "1gx48qjiahlwflmjlkndp3ricd03jmzfx7i9ffgq7a2i6gcm36zp";
  };

  checkInputs = [ boto3 pytest pytestcov packaging hypothesis ];
  nativeBuildInputs = [ cython gdal ];
  propagatedBuildInputs = [ gdal numpy attrs affine cligj click-plugins snuggs ];

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    license = licenses.bsd3;
    homepage = https://rasterio.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ mredaelli ];
  };
}
