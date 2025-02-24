{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  versioningit,

  # dependencies
  broadbean,
  cf-xarray,
  dask,
  h5netcdf,
  h5py,
  ipykernel,
  ipython,
  ipywidgets,
  jsonschema,
  libcst,
  matplotlib,
  numpy,
  opentelemetry-api,
  packaging,
  pandas,
  pillow,
  pyarrow,
  pyvisa,
  ruamel-yaml,
  tabulate,
  tqdm,
  typing-extensions,
  uncertainties,
  websockets,
  wrapt,
  xarray,

  # optional-dependencies
  furo,
  jinja2,
  nbsphinx,
  pyvisa-sim,
  scipy,
  sphinx,
  sphinx-issues,
  towncrier,

  # tests
  deepdiff,
  hypothesis,
  lxml,
  pip,
  pytest-asyncio,
  pytest-mock,
  pytest-rerunfailures,
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "qcodes";
  version = "0.51.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "Qcodes";
    tag = "v${version}";
    hash = "sha256-QgCMoZrC3ZCo8yayRXw9fvBj5xi+XH2x/E1MuQFULPo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'default-version = "0.0"' 'default-version = "${version}"'
  '';

  build-system = [
    setuptools
    versioningit
  ];

  dependencies = [
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
    opentelemetry-api
    packaging
    pandas
    pillow
    pyarrow
    pyvisa
    ruamel-yaml
    tabulate
    tqdm
    typing-extensions
    uncertainties
    websockets
    wrapt
    xarray
  ];

  optional-dependencies = {
    docs = [
      # autodocsumm
      furo
      jinja2
      nbsphinx
      pyvisa-sim
      # qcodes-loop
      scipy
      sphinx
      # sphinx-favicon
      sphinx-issues
      # sphinx-jsonschema
      # sphinxcontrib-towncrier
      towncrier
    ];
    loop = [
      # qcodes-loop
    ];
    refactor = [
      libcst
    ];
    zurichinstruments = [
      # zhinst-qcodes
    ];
  };

  nativeCheckInputs = [
    deepdiff
    hypothesis
    libcst
    lxml
    pip
    pytest-asyncio
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    pyvisa-sim
    sphinx
    writableTmpDirAsHomeHook
  ];

  __darwinAllowLocalNetworking = true;

  pytestFlagsArray = [
    "-v"
    # Follow upstream with settings
    "-m 'not serial'"
    "--hypothesis-profile ci"
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

    # more flaky tests
    # https://github.com/microsoft/Qcodes/issues/5551
    "test_query_close_once_at_init"
    "test_step_ramp"
  ];

  pythonImportsCheck = [ "qcodes" ];

  meta = {
    description = "Python-based data acquisition framework";
    changelog = "https://github.com/QCoDeS/Qcodes/releases/tag/v${version}";
    downloadPage = "https://github.com/QCoDeS/Qcodes";
    homepage = "https://qcodes.github.io/Qcodes/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
