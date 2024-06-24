{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  appdirs,
  flexcache,
  flexparser,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-subtests,
  pytest-benchmark,
  numpy,
  matplotlib,
  uncertainties,
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.24";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xsfAJ7ghQT2xrEazt70pZZKEi1rsKaiM/G43j9E3GQM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    appdirs
    flexcache
    flexparser
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
    pytest-benchmark
    numpy
    matplotlib
    uncertainties
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # https://github.com/hgrecco/pint/issues/1898
    "test_load_definitions_stage_2"
    # pytest8 deprecation
    "test_nonnumeric_magnitudes"
  ];

  meta = with lib; {
    changelog = "https://github.com/hgrecco/pint/blob/${version}/CHANGES";
    description = "Physical quantities module";
    mainProgram = "pint-convert";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with maintainers; [ doronbehar ];
  };
}
