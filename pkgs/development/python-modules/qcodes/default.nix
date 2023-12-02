{ lib
, broadbean
, buildPythonPackage
, cf-xarray
, dask
, deepdiff
, fetchFromGitHub
, h5netcdf
, h5py
, hypothesis
, importlib-metadata
, ipykernel
, ipython
, ipywidgets
, jsonschema
, lxml
, matplotlib
, numpy
, opencensus
, opencensus-ext-azure
, opentelemetry-api
, packaging
, pandas
, pillow
, pip
, pytest-asyncio
, pytest-mock
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pyvisa
, pyvisa-sim
, rsa
, ruamel-yaml
, setuptools
, sphinx
, tabulate
, tqdm
, typing-extensions
, uncertainties
, versioningit
, websockets
, wheel
, wrapt
, xarray
}:

buildPythonPackage rec {
  pname = "qcodes";
  version = "0.42.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "QCoDeS";
    repo = "Qcodes";
    rev = "refs/tags/v${version}";
    hash = "sha256-oNQLIL5L3gtFS6yxqgLDI1s4s9UYqxGc8ASqHuZv6Rk=";
  };

  nativeBuildInputs = [
    setuptools
    versioningit
    wheel
  ];

  propagatedBuildInputs = [
    broadbean
    cf-xarray
    dask
    h5netcdf
    h5py
    ipykernel
    ipython
    ipywidgets
    jsonschema
    matplotlib
    numpy
    opencensus
    opencensus-ext-azure
    opentelemetry-api
    packaging
    pandas
    pillow
    pyvisa
    rsa
    ruamel-yaml
    tabulate
    tqdm
    typing-extensions
    uncertainties
    websockets
    wrapt
    xarray
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    deepdiff
    hypothesis
    lxml
    pip
    pytest-asyncio
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    pyvisa-sim
    sphinx
  ];

  __darwinAllowLocalNetworking = true;

  pytestFlagsArray = [
    "-v"
    "-n"
    "$NIX_BUILD_CORES"
    # Follow upstream with settings
    "--durations=20"
  ];

  disabledTestPaths = [
    # Test depends on qcodes-loop, causing a cyclic dependency
    "tests/dataset/measurement/test_load_legacy_data.py"
    # TypeError
    "tests/dataset/test_dataset_basic.py"
  ];

  disabledTests = [
    # Tests are time-sensitive and power-consuming
    # Those tests fails repeatably and are flaky
    "test_access_channels_by_slice"
    "test_aggregator"
    "test_datasaver"
    "test_do1d_additional_setpoints_shape"
    "test_dond_1d_additional_setpoints_shape"
    "test_field_limits"
    "test_get_array_in_scalar_param_data"
    "test_get_parameter_data"
    "test_ramp_safely"
  ];

  pythonImportsCheck = [
    "qcodes"
  ];

  postInstall = ''
    export HOME="$TMPDIR"
  '';

  meta = with lib; {
    description = "Python-based data acquisition framework";
    changelog = "https://github.com/QCoDeS/Qcodes/releases/tag/v${version}";
    downloadPage = "https://github.com/QCoDeS/Qcodes";
    homepage = "https://qcodes.github.io/Qcodes/";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
