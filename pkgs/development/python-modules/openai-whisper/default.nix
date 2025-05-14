{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  replaceVars,

  # build-system
  setuptools,

  # runtime
  ffmpeg-headless,

  # dependencies
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
  writableTmpDirAsHomeHook,
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
    (replaceVars ./ffmpeg-path.patch {
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

  nativeCheckInputs = [
    pytestCheckHook
    scipy
    writableTmpDirAsHomeHook
  ];

  disabledTests =
    [
      # requires network access to download models
      "test_transcribe"

      # requires NVIDIA drivers
      "test_dtw_cuda_equivalence"
      "test_median_filter_equivalence"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # Fatal Python error: Segmentation fault
      "test_dtw"
    ];

  meta = {
    changelog = "https://github.com/openai/whisper/blob/v${version}/CHANGELOG.md";
    description = "General-purpose speech recognition model";
    mainProgram = "whisper";
    homepage = "https://github.com/openai/whisper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      MayNiklas
    ];
  };
}
