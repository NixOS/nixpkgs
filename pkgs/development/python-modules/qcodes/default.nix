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
, importlib-resources
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
  version = "0.38.1";

  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-whUGkRvYQOdYxWoj7qhv2kiiyTwq3ZLLipI424PBzFg=";
  };

  nativeBuildInputs = [ setuptools versioningit ];

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
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  passthru.optional-dependencies = {
    loop = [
      qcodes-loop
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    deepdiff
    hypothesis
    lxml
    pytest-asyncio
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pyvisa-sim
    sphinx
  ];

  disabledTestPaths = [
    # depends on qcodes-loop, causing a cyclic dependency
    "qcodes/tests/dataset/measurement/test_load_legacy_data.py"
  ];

  pythonImportsCheck = [ "qcodes" ];

  postInstall = ''
    export HOME="$TMPDIR"
  '';

  meta = {
    homepage = "https://qcodes.github.io/Qcodes/";
    description = "Python-based data acquisition framework";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
