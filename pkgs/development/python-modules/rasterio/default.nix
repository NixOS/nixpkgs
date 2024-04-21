{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, stdenv
, testers

, affine
, attrs
, boto3
, certifi
, click
, click-plugins
, cligj
, cython_3
, gdal
, hypothesis
, ipython
, matplotlib
, numpy
, packaging
, pytest-randomly
, setuptools
, shapely
, snuggs
, wheel

, rasterio  # required to run version test
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.3.10";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = "refs/tags/${version}";
    hash = "sha256-FidUaSpbTR8X1/Cqy/IwApkOOl2RRtPqYJaSISRPThI=";
  };

  postPatch = ''
    # remove useless import statement requiring distutils to be present at the runtime
    substituteInPlace rasterio/rio/calc.py \
      --replace-fail "from distutils.version import LooseVersion" ""

    # relax dependency on yet non-packaged, RC version of numpy
    substituteInPlace pyproject.toml \
      --replace-fail "numpy==2.0.0rc1" "numpy"
    '';

  nativeBuildInputs = [
    cython_3
    gdal
    numpy
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    affine
    attrs
    certifi
    click
    click-plugins
    cligj
    numpy
    snuggs
  ];

  passthru.optional-dependencies = {
    ipython = [
      ipython
    ];
    plot = [
      matplotlib
    ];
    s3 = [
      boto3
    ];
  };

  nativeCheckInputs = [
    boto3
    hypothesis
    packaging
    pytestCheckHook
    pytest-randomly
    shapely
  ];

  doCheck = true;

  preCheck = ''
    rm -r rasterio # prevent importing local rasterio
  '';

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  disabledTests = [
    # flaky
    "test_outer_boundless_pixel_fidelity"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_reproject_error_propagation"
  ];

  pythonImportsCheck = [
    "rasterio"
  ];

  passthru.tests.version = testers.testVersion {
    package = rasterio;
    version = version;
    command = "${rasterio}/bin/rio --version";
  };

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    mainProgram = "rio";
    homepage = "https://rasterio.readthedocs.io/";
    changelog = "https://github.com/rasterio/rasterio/blob/${version}/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
