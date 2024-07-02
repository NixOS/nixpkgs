{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "pint";
    rev = "refs/tags/${version}";
    hash = "sha256-zMcLC3SSl/W7+xX4ah3ZV7fN/LIGJzatqH4MNK8/fec=";
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

    # Both uncertainties and numpy are not necessarily needed for every
    # function of pint, but needed for the pint-convert executable which we
    # necessarily distribute with this package as it is.
    uncertainties
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
    pytest-benchmark
    matplotlib
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    changelog = "https://github.com/hgrecco/pint/blob/${version}/CHANGES";
    description = "Physical quantities module";
    mainProgram = "pint-convert";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with maintainers; [ doronbehar ];
  };
}
