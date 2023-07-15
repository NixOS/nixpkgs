{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, versioningit

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
  version = "0.39.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zKn9LN7FBxKUfYSxUV1O6fB2s/B5bQpGDZTrK4DcxmU=";
  };

  nativeBuildInputs = [
    setuptools
    versioningit
  ];

  propagatedBuildInputs = [
    broadbean
    h5netcdf
    h5py
    ipywidgets
    ipykernel
    jsonschema
    matplotlib
    numpy
    opencensus
    opencensus-ext-azure
    packaging
    pandas
    pyvisa
    ruamel-yaml
    tabulate
    typing-extensions
    tqdm
    uncertainties
    websockets
    wrapt
    xarray
    ipython
    pillow
    rsa
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
    # depends on qcodes-loop, causing a cyclic dependency
    "qcodes/tests/dataset/measurement/test_load_legacy_data.py"
  ];

  pythonImportsCheck = [
    "qcodes"
  ];

  postInstall = ''
    export HOME="$TMPDIR"
  '';

  meta = with lib; {
    homepage = "https://qcodes.github.io/Qcodes/";
    description = "Python-based data acquisition framework";
    changelog = "https://github.com/QCoDeS/Qcodes/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
