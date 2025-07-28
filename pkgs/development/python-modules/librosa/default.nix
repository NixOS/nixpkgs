{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  audioread,
  decorator,
  joblib,
  lazy-loader,
  matplotlib,
  msgpack,
  numba,
  numpy,
  pooch,
  scikit-learn,
  scipy,
  soundfile,
  soxr,
  standard-aifc,
  standard-sunau,
  typing-extensions,

  # tests
  ffmpeg-headless,
  packaging,
  pytest-cov-stub,
  pytest-mpl,
  pytestCheckHook,
  resampy,
  samplerate,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "librosa";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "librosa";
    repo = "librosa";
    tag = version;
    fetchSubmodules = true; # for test data
    hash = "sha256-T58J/Gi3tHzelr4enbYJi1KmO46QxE5Zlhkc0+EgvRg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    audioread
    decorator
    joblib
    lazy-loader
    msgpack
    numba
    numpy
    pooch
    scikit-learn
    scipy
    soundfile
    soxr
    standard-aifc
    standard-sunau
    typing-extensions
  ];

  optional-dependencies.matplotlib = [ matplotlib ];

  # check that import works, this allows to capture errors like https://github.com/librosa/librosa/issues/1160
  pythonImportsCheck = [ "librosa" ];

  nativeCheckInputs = [
    ffmpeg-headless
    packaging
    pytest-cov-stub
    pytest-mpl
    pytestCheckHook
    resampy
    samplerate
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.matplotlib;

  disabledTests = [
    # requires network access
    "test_example"
    "test_example_info"
    "test_load_resample"
    "test_cite_released"
    "test_cite_badversion"
    "test_cite_unreleased"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # crashing the python interpreter
    "test_unknown_time_unit"
    "test_unknown_wavaxis"
    "test_waveshow_unknown_wavaxis"
    "test_waveshow_bad_maxpoints"
    "test_waveshow_deladaptor"
    "test_waveshow_disconnect"
    "test_unknown_axis"
    "test_axis_bound_warning"
    "test_auto_aspect"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Flaky (numerical comparison fails)
    "test_istft_multi"
    "test_pitch_shift_multi"
    "test_time_stretch_multi"
  ];

  meta = {
    description = "Python library for audio and music analysis";
    homepage = "https://github.com/librosa/librosa";
    changelog = "https://github.com/librosa/librosa/releases/tag/${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ GuillaumeDesforges ];
  };
}
