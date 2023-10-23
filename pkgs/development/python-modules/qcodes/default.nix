{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, versioningit
, wheel

  # mandatory
, broadbean
, h5netcdf
, h5py
, importlib-metadata
, ipywidgets
, ipykernel
, jsonschema
, matplotlib
, numpy
, opencensus
, opencensus-ext-azure
, opentelemetry-api
, packaging
, pandas
, pyvisa
, ruamel-yaml
, tabulate
, typing-extensions
, tqdm
, uncertainties
, websockets
, wrapt
, xarray
, ipython
, pillow
, rsa

  # optional
, qcodes-loop
, slack-sdk

  # test
, pip
, pytestCheckHook
, deepdiff
, hypothesis
, lxml
, pytest-asyncio
, pytest-mock
, pytest-rerunfailures
, pytest-xdist
, pyvisa-sim
, sphinx
}:

buildPythonPackage rec {
  pname = "qcodes";
  version = "0.40.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C8/ltX3tSxCbbheuel3BjIkRBl/E92lK709QYx+2FL0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'versioningit ~=' 'versioningit >='
  '';

  nativeBuildInputs = [
    setuptools
    versioningit
    wheel
  ];

  propagatedBuildInputs = [
    broadbean
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
    slack = [
      slack-sdk
    ];
  };

  __darwinAllowLocalNetworking = true;

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

  pytestFlagsArray = [
    # Follow upstream with settings
    "--durations=20"
  ];

  disabledTestPaths = [
    # Test depends on qcodes-loop, causing a cyclic dependency
    "qcodes/tests/dataset/measurement/test_load_legacy_data.py"
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
    changelog = "https://github.com/QCoDeS/Qcodes/releases/tag/v${version}";
    description = "Python-based data acquisition framework";
    downloadPage = "https://github.com/QCoDeS/Qcodes";
    homepage = "https://qcodes.github.io/Qcodes/";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
