{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  librosa,
  matplotlib,
  numpy,
  pydub,
  pytestCheckHook,
  pyyaml,
  soundfile,
  torch,
  torchaudio,
  uv-build,
}:

buildPythonPackage {
  pname = "resemble-perth";
  version = "1.0.1-unstable-2025-12-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "resemble-ai";
    repo = "Perth";
    rev = "ce86c49d029f42272c1902eccb675556b9ed2330";
    hash = "sha256-sVsuzdguQyWYHl1QgpkbqpQIlwM4GTRNcfudkt7ajb0=";
  };

  build-system = [
    uv-build
  ];

  # see https://github.com/resemble-ai/Perth/pull/15
  pythonRemoveDeps = [
    "bitstring"
    "bitstring"
    "matplotlib"
    "matplotlib"
    "pandas"
    "pandas"
    "pillow"
    "praat-parselmouth"
    "pyloudnorm"
    "pyloudnorm"
    "pyrubberband"
    "pywavelets"
    "scikit-learn"
    "sox"
    "tabulate"
    "tensorboard"
    "tqdm"
  ];

  dependencies = [
    librosa
    numpy
    pydub
    pyyaml
    soundfile
    torch
    torchaudio
  ];

  preInstallCheck = ''
    export NUMBA_CACHE_DIR=$TMPDIR
  '';

  pythonImportsCheck = [ "perth" ];

  nativeCheckInputs = [
    matplotlib
    pytestCheckHook
  ];

  pytestFlags = [ "./tests" ];

  meta = {
    description = "Audio Watermarking and Detection Library";
    homepage = "https://github.com/resemble-ai/Perth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
