{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  fetchpatch2,

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
  version = "0.10.2.post1";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "librosa";
    repo = "librosa";
    tag = version;
    fetchSubmodules = true; # for test data
    hash = "sha256-0FbKVAFWmcFTW2dR27nif6hPZeIxFWYF1gTm4BEJZ/Q=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/librosa/librosa/issues/1849
      name = "librosa-scipy-1.14-compat.patch";
      url = "https://github.com/librosa/librosa/commit/d0a12c87cdff715ffb8ac1c7383bba1031aa71e4.patch";
      hash = "sha256-NHuGo4U1FRikb5OIkycQBvuZ+0OdG/VykTcuhXkLUug=";
    })
    # Fix numpy2 test incompatibilities
    # TODO: remove when updating to the next release
    (fetchpatch2 {
      name = "numpy2-support-tests";
      url = "https://github.com/librosa/librosa/commit/7eb0a09e703a72a5979049ec546a522c70285aff.patch";
      hash = "sha256-m9UpSDKOAr7qzTtahVQktu259cp8QDYjDChpQV0xuY0=";
    })
  ];

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
    scipy
    scikit-learn
    soundfile
    soxr
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
  ] ++ optional-dependencies.matplotlib;

  disabledTests =
    [
      # requires network access
      "test_example"
      "test_example_info"
      "test_load_resample"
      "test_cite_released"
      "test_cite_badversion"
      "test_cite_unreleased"
      # assert 22050 == np.int64(30720)
      "test_stream"
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
    badPlatforms = [
      # Several non-deterministic occurrences of "Fatal Python error: Segmentation fault", both in
      # numpy's and in this package's code.
      "aarch64-linux"
    ];
  };
}
