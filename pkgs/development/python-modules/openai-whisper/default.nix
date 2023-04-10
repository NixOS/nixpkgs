{ lib
, fetchFromGitHub
, buildPythonPackage
, substituteAll
, cudaSupport ? false

# runtime
, ffmpeg

# propagates
, numpy
, torch
, torchWithCuda
, tqdm
, more-itertools
, transformers
, ffmpeg-python
, numba
, openai-triton
, scipy
, tiktoken

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whisper";
  version = "20230314";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qQCELjRFeRCT1k1CBc3netRtFvt+an/EbkrgnmiX/mc=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      inherit ffmpeg;
    })
  ];

  propagatedBuildInputs = [
    numpy
    tqdm
    more-itertools
    transformers
    ffmpeg-python
    numba
    scipy
    tiktoken
  ] ++ lib.optionals (!cudaSupport) [
    torch
  ] ++ lib.optionals (cudaSupport) [
    openai-triton
    torchWithCuda
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "tiktoken==0.3.1" "tiktoken>=0.3.1"
  ''
  # openai-triton is only needed for CUDA support.
  # triton needs CUDA to be build.
  # -> by making it optional, we can build whisper without unfree packages enabled
  + lib.optionalString (!cudaSupport) ''
    sed -i '/if sys.platform.startswith("linux") and platform.machine() == "x86_64":/{N;d}' setup.py
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # requires network access to download models
    "test_tokenizer"
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
