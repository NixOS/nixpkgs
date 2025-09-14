{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  matplotlib,
  numpy,
  pandas,
  pywavelets,
  requests,
  scikit-learn,
  scipy,

  # tests
  astropy,
  coverage,
  mock,
  plotly,
  pytest-cov-stub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "neurokit2";
  version = "0.2.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neuropsychology";
    repo = "NeuroKit";
    tag = "v${version}";
    hash = "sha256-gn02l0vYl+/7hXp4gFVlgblxC4dewXckW3JL3wPC89Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner", ' ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
    numpy
    pandas
    pywavelets
    requests
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    mock
    plotly
    astropy
    coverage
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Crash in matplotlib (Fatal Python error: Aborted)
    "test_events_plot"
  ];

  disabledTestPaths = [
    # Required dependencies not available in nixpkgs
    "tests/tests_bio.py"
    "tests/tests_complexity.py"
    "tests/tests_data.py"
    "tests/tests_ecg.py"
    "tests/tests_ecg_delineate.py"
    "tests/tests_ecg_findpeaks.py"
    "tests/tests_eda.py"
    "tests/tests_eeg.py"
    "tests/tests_emg.py"
    "tests/tests_eog.py"
    "tests/tests_epochs.py"
    "tests/tests_hrv.py"
    "tests/tests_ppg.py"
    "tests/tests_rsp.py"
    "tests/tests_signal.py"

    # Dependency is broken `mne-python`
    "tests/tests_microstates.py"
  ];

  pytestFlags = [
    # Otherwise, test collection fails with:
    # AttributeError: module 'scipy.ndimage._delegators' has no attribute '@py_builtins_signature'. Did you mean: 'grey_dilation_signature'?
    # https://github.com/scipy/scipy/issues/22236
    "--assert=plain"
  ];

  pythonImportsCheck = [
    "neurokit2"
  ];

  meta = {
    description = "Python Toolbox for Neurophysiological Signal Processing";
    homepage = "https://github.com/neuropsychology/NeuroKit";
    changelog = "https://github.com/neuropsychology/NeuroKit/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
