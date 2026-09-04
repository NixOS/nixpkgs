{
  lib,
  stdenv,
  fetchurl,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scipy,
  torch,

  # tests
  librosa,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  choice = fetchurl {
    url = "https://librosa.org/data/audio/admiralbob77_-_Choice_-_Drum-bass.ogg";
    hash = "sha256-rGRPlkXnwVF05KT4Vh5NFEjX9uWf9rBVazEOu87Yebw=";
  };
  vibeace = fetchurl {
    url = "https://librosa.org/data/audio/Kevin_MacLeod_-_Vibe_Ace.ogg";
    hash = "sha256-bCOu091apX8rFlLsq2jRXZuCrSV/VOY56yiAygm8EYo=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "nnaudio";
  version = "0.2.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "KinWaiCheuk";
    repo = "nnAudio";
    rev = "e77d9f874cf37b273f44f68aefbd32fb0b979912";
    hash = "sha256-uJySa2A7IbuY/9Wq/w9gRkBk1NhMrhipyclOWO5koHE=";
  };

  sourceRoot = "${finalAttrs.src.name}/Installation";

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    torch
  ];

  nativeCheckInputs = [
    librosa
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    mkdir -p $HOME/.cache/librosa/
    cp ${choice} $HOME/.cache/librosa/admiralbob77_-_Choice_-_Drum-bass.ogg
    cp ${vibeace} $HOME/.cache/librosa/Kevin_MacLeod_-_Vibe_Ace.ogg
    export NUMBA_CACHE_DIR=$(mktemp -d)
  '';

  # urllib3.exceptions.MaxRetryError
  # On darwin the tests fail to locate the audio files and fallback to downloading them from the
  # internet
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # AttributeError: module 'scipy.signal' has no attribute 'blackmanharris'
    "test_cfp_original[cpu]"
    "test_cfp_new[cpu]"
    # Test fixture matrix has other values
    "test_vqt_gamma_zero[cpu]"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Test fixture matrix has other values
    "test_cqt_1992_v2_linear[cpu]"
    "test_cqt_1992_v2_log[cpu]"
  ];

  pythonImportsCheck = [ "nnAudio" ];

  meta = {
    description = "Fast GPU audio processing toolbox with 1D convolutional neural network";
    homepage = "https://github.com/KinWaiCheuk/nnAudio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
