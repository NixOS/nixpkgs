{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # runtime
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
  pytest-mpl,
  pytestCheckHook,
  resampy,
  samplerate,
}:

buildPythonPackage rec {
  pname = "librosa";
  version = "0.10.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "librosa";
    repo = "librosa";
    rev = "refs/tags/${version}";
    fetchSubmodules = true; # for test data
    hash = "sha256-zUKljPKWOhyb3Zv4KEUcvLsVkxVhL+rzErKycAl6jIg=";
  };

  nativeBuildInputs = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov-report term-missing --cov librosa --cov-report=xml " ""
  '';

  propagatedBuildInputs = [
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

  passthru.optional-dependencies.matplotlib = [ matplotlib ];

  # check that import works, this allows to capture errors like https://github.com/librosa/librosa/issues/1160
  pythonImportsCheck = [ "librosa" ];

  nativeCheckInputs = [
    ffmpeg-headless
    packaging
    pytest-mpl
    pytestCheckHook
    resampy
    samplerate
  ] ++ passthru.optional-dependencies.matplotlib;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests =
    [
      # requires network access
      "test_example"
      "test_example_info"
      "test_load_resample"
      "test_cite_released"
      "test_cite_badversion"
      "test_cite_unreleased"
    ]
    ++ lib.optionals stdenv.isDarwin [
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
    ];

  meta = with lib; {
    description = "Python library for audio and music analysis";
    homepage = "https://github.com/librosa/librosa";
    changelog = "https://github.com/librosa/librosa/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
