{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build time
, cython
, gdal

# runtime
, affine
, attrs
, boto3
, click
, click-plugins
, cligj
, matplotlib
, numpy
, snuggs
, setuptools

# tests
, hypothesis
, packaging
, pytest-randomly
, pytestCheckHook
, shapely
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.3.0"; # not x.y[ab]z, those are alpha/beta versions
  format = "pyproject";
  disabled = pythonOlder "3.6";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = "refs/tags/${version}";
    hash = "sha256-CBnG1zNMOL3rAmnErv7XZZ2Cu9W+DnRPcjtKdmYXHUA=";
  };

  nativeBuildInputs = [
    cython
    gdal
  ];

  propagatedBuildInputs = [
    affine
    attrs
    boto3
    click
    click-plugins
    cligj
    matplotlib
    numpy
    snuggs
    setuptools # needs pkg_resources at runtime
  ];

  preCheck = ''
    rm -rf rasterio
  '';

  checkInputs = [
    pytest-randomly
    pytestCheckHook
    packaging
    hypothesis
    shapely
  ];

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_reproject_error_propagation"
  ];

  pythonImportsCheck = [
    "rasterio"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/rio --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    homepage = "https://rasterio.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mredaelli ];
  };
}
