{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  boost-histogram,
  histoprint,
  numpy,

  # tests
  pytestCheckHook,
  pytest-mpl,
}:

buildPythonPackage (finalAttrs: {
  pname = "hist";
  version = "2.12.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "hist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rlUZJj9hER0oNSNlEpQ0623MMlh4b/3W1Do8dQLdi10=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    boost-histogram
    histoprint
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # line 23: 92372 Trace/BPT trap: 5
    "test_to_hist_empty"
  ];

  pythonImportsCheck = [ "hist" ];

  meta = {
    description = "Histogramming for analysis powered by boost-histogram";
    mainProgram = "";
    homepage = "https://hist.readthedocs.io/";
    downloadPage = "https://github.com/scikit-hep/hist";
    changelog = "https://github.com/scikit-hep/hist/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
