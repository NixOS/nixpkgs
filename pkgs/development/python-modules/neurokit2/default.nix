{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytest,
  scipy,
  scikit-learn,
  pandas,
  matplotlib,
  requests,
  cvxopt,
  biosppy,
  pytest-cov-stub,
  mock,
  plotly,
  astropy,
  coverage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "neurokit2";
  version = "0.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neuropsychology";
    repo = "NeuroKit";
    tag = "v${version}";
    hash = "sha256-e/B1JvO6uYZ6iVskFvxZLSSXi0cPep9bBZ0JXZTVS28=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' '"pytest"'
  '';

  build-system = [
    setuptools
    pytest
  ];

  dependencies = [
    scipy
    scikit-learn
    pandas
    matplotlib
    requests
    cvxopt
    biosppy
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    mock
    plotly
    astropy
    coverage
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Crash in matplotlib (Fatal Python error: Aborted)
    "test_events_plot"
  ];

  disabledTestPaths = [
    # Required dependencies not available in nixpkgs
    "tests/tests_complexity.py"
    "tests/tests_eeg.py"
    "tests/tests_eog.py"
    "tests/tests_ecg.py"
    "tests/tests_bio.py"
    "tests/tests_data.py"
    "tests/tests_epochs.py"
    "tests/tests_ecg_findpeaks.py"
    "tests/tests_eda.py"
    "tests/tests_emg.py"
    "tests/tests_hrv.py"
    "tests/tests_rsp.py"
    "tests/tests_ppg.py"
    "tests/tests_signal.py"

    # Dependency is broken `mne-python`
    "tests/tests_microstates.py"
  ];

  pythonImportsCheck = [
    "neurokit2"
  ];

  meta = {
    description = "Python Toolbox for Neurophysiological Signal Processing";
    homepage = "https://github.com/neuropsychology/NeuroKit";
    changelog = "https://github.com/neuropsychology/NeuroKit/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
