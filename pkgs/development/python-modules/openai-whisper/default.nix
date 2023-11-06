{ lib
, fetchFromGitHub
, buildPythonPackage
, substituteAll
, cudaSupport ? false

# runtime
, ffmpeg-headless

# propagates
, numpy
, torch
, torchWithCuda
, tqdm
, more-itertools
, transformers
, numba
, openai-triton
, scipy
, tiktoken

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whisper";
  version = "20231106";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kpQ3q2dMts6OzEx9qjFp7PZvZ47Se6+nzImqBhExiWw=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      ffmpeg = ffmpeg-headless;
    })
  ];

  propagatedBuildInputs = [
    numpy
    tqdm
    more-itertools
    transformers
    numba
    scipy
    tiktoken
  ] ++ lib.optionals (!cudaSupport) [
    torch
  ] ++ lib.optionals (cudaSupport) [
    openai-triton
    torchWithCuda
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # requires network access to download models
    "test_transcribe"
    # requires NVIDIA drivers
    "test_dtw_cuda_equivalence"
    "test_median_filter_equivalence"
  ];

  meta = with lib; {
    changelog = "https://github.com/openai/whisper/blob/v$[version}/CHANGELOG.md";
    description = "General-purpose speech recognition model";
    homepage = "https://github.com/openai/whisper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa MayNiklas ];
  };
}
