{ buildPythonPackage, lib, fetchFromGitHub, isPy3k
, cython, setuptools
, numpy, affine, attrs, cligj, click-plugins, snuggs, gdal
, pytest, pytestcov, packaging, hypothesis, boto3, mock
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.1.3";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "rasterio";
    rev = version;
    sha256 = "0i081bkmv7qw24ivmdh92ma6x0hnjlf8jgj6rp2c3rb8hjzmi452";
  };

  checkInputs = [ boto3 pytest pytestcov packaging hypothesis ] ++ lib.optional (!isPy3k) mock;
  nativeBuildInputs = [ cython gdal ];
  propagatedBuildInputs = [ gdal numpy attrs affine cligj click-plugins snuggs setuptools ];

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    license = licenses.bsd3;
    homepage = "https://rasterio.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };
}
