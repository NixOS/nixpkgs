{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# runtime
, audioread
, decorator
, joblib
, lazy-loader
, matplotlib
, msgpack
, numba
, numpy
, pooch
, scikit-learn
, scipy
, soundfile
, soxr
, typing-extensions

# tests
, ffmpeg-headless
, packaging
, pytest-mpl
, pytestCheckHook
, resampy
, samplerate
}:

buildPythonPackage rec {
  pname = "librosa";
  version = "0.10.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "librosa";
    repo = "librosa";
    rev = "refs/tags/${version}";
    fetchSubmodules = true; # for test data
    hash = "sha256-MXzPIcbG8b1JwhEyAZG4DRObGaHq+ipVHMrZCzaxLdE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report term-missing --cov librosa --cov-report=xml " ""
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

  passthru.optional-dependencies.matplotlib = [
    matplotlib
  ];

  # check that import works, this allows to capture errors like https://github.com/librosa/librosa/issues/1160
  pythonImportsCheck = [
    "librosa"
  ];

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

  disabledTests = [
    # requires network access
    "test_example"
    "test_example_info"
    "test_load_resample"
  ];

  meta = with lib; {
    description = "Python library for audio and music analysis";
    homepage = "https://github.com/librosa/librosa";
    changelog = "https://github.com/librosa/librosa/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };

}
