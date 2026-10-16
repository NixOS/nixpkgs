{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
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

  # tests
  packaging,
  pytest-cov-stub,
  pytest-mpl,
  pytestCheckHook,
  resampy,
  samplerate,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "librosa";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "librosa";
    repo = "librosa";
    tag = finalAttrs.version;
    fetchSubmodules = true; # for test data
    hash = "sha256-+RjGbnAP0rYjRe/QVwKsCUIhRZM8DzY1JnmoJvDagwM=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
  ];

  optional-dependencies.display = [ matplotlib ];

  # check that import works, this allows to capture errors like https://github.com/librosa/librosa/issues/1160
  pythonImportsCheck = [ "librosa" ];

  nativeCheckInputs = [
    packaging
    pytest-cov-stub
    pytest-mpl
    pytestCheckHook
    resampy
    samplerate
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.display;

  # Prevents 'Fatal Python error: Aborted' on darwin during checkPhase
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export MPLBACKEND="Agg"
  '';

  disabledTests = [
    # requires network access
    "test_cite_badversion"
    "test_cite_released"
    "test_cite_unreleased"
    "test_example"
    "test_example_info"
    "test_load_resample"
    "test_loadx"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # AssertionError (numerical comparison fails)
    "test_beat_track_multi"
    "test_beat_track_multi_bpm_vector"
    "test_melspectrogram_multi"
    "test_melspectrogram_multi_time"
    "test_nnls_matrix"
    "test_nnls_multiblock"
    "test_onset_detect"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Flaky (numerical comparison fails)
    "test_istft_multi"
    "test_pitch_shift_multi"
    "test_time_stretch_multi"
    "test_resample_multichannel"
  ];

  meta = {
    description = "Python library for audio and music analysis";
    homepage = "https://github.com/librosa/librosa";
    changelog = "https://github.com/librosa/librosa/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ carlthome ];
  };
})
