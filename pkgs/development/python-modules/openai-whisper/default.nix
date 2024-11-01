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
  version = "20240930";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6wfHJM2pg+y1qUfVF1VRG86G3CtQ+UNIwMXR8pPi2k4=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      ffmpeg = ffmpeg-headless;
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
