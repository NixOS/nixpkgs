{ buildPythonPackage, lib, fetchFromGitHub, isPy3k
, cython
, numpy, affine, attrs, cligj, click-plugins, snuggs, gdal
, pytest, pytestcov, packaging, hypothesis, boto3, mock
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.0.25";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "rasterio";
    rev = version;
    sha256 = "15m0ajcrxjdzahdkxa3mylk87l31zz48k99bvmmx96hcl31cf347";
  };

  checkInputs = [ boto3 pytest pytestcov packaging hypothesis ] ++ lib.optional (!isPy3k) mock;
  nativeBuildInputs = [ cython gdal ];
  propagatedBuildInputs = [ gdal numpy attrs affine cligj click-plugins snuggs ];

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    license = licenses.bsd3;
    homepage = https://rasterio.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ mredaelli ];
  };
}
