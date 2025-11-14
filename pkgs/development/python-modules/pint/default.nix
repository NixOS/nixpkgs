{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  flexcache,
  flexparser,
  platformdirs,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-subtests,
  pytest-benchmark,
  numpy,
  matplotlib,
  uncertainties,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.25.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "pint";
    tag = version;
    hash = "sha256-Ushg7e920TTW7AYXg5C076Bl/yWPLO+H8I3Ytlc7OKc=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    flexcache
    flexparser
    platformdirs
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
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = {
    changelog = "https://github.com/hgrecco/pint/blob/${version}/CHANGES";
    description = "Physical quantities module";
    mainProgram = "pint-convert";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
