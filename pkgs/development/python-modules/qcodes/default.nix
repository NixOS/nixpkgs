{ lib
, broadbean
, buildPythonPackage
, cf-xarray
, dask
, deepdiff
, fetchPypi
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
, qcodes-loop
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
  version = "0.41.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3Ncg51E4KYbvzlEyesVbTmzmz+UPfFkj3tudVbNYqHQ=";
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

  passthru.optional-dependencies = {
    loop = [
      qcodes-loop
    ];
  };

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
    # Follow upstream with settings
    "--durations=20"
  ];

  disabledTestPaths = [
    # Test depends on qcodes-loop, causing a cyclic dependency
    "qcodes/tests/dataset/measurement/test_load_legacy_data.py"
    # TypeError
    "qcodes/tests/dataset/test_dataset_basic.py"
  ];

  disabledTests = [
    # Tests are time-sensitive and power-consuming
    # Those tests fails repeatably
    "test_access_channels_by_slice"
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
