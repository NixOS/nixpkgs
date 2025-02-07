{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  substituteAll,

  # build-system
  setuptools,

  # runtime
  ffmpeg-headless,

  # propagates
  more-itertools,
  numba,
  numpy,
  triton,
  tiktoken,
  torch,
  tqdm,

  # tests
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "whisper";
  version = "20240930-unstable-2025-01-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "whisper";
    rev = "517a43ecd132a2089d85f4ebc044728a71d49f6e";
    hash = "sha256-RYcQC70E27gtW4gzoPJU132Dm7CnSg8d2/GEfyUyXU4=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      ffmpeg = ffmpeg-headless;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    more-itertools
    numba
    numpy
    tiktoken
    torch
    tqdm
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform triton) [ triton ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  disabledTests = [
    # requires network access to download models
    "test_transcribe"
    # requires NVIDIA drivers
    "test_dtw_cuda_equivalence"
    "test_median_filter_equivalence"
  ];

  meta = with lib; {
    changelog = "https://github.com/openai/whisper/blob/v${version}/CHANGELOG.md";
    description = "General-purpose speech recognition model";
    mainProgram = "whisper";
    homepage = "https://github.com/openai/whisper";
    license = licenses.mit;
    maintainers = with maintainers; [
      hexa
      MayNiklas
    ];
  };
}
