{ lib
, fetchFromGitHub
, buildPythonPackage
, substituteAll

# runtime
, ffmpeg

# propagates
, numpy
, torch
, tqdm
, more-itertools
, transformers
, ffmpeg-python

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whisper";
  version = "unstable-2022-09-30";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "60132ade70e00b843d93542fcb37b58c0d8bf9e7";
    hash = "sha256-4mhlCvewA0bVo5bq2sbSEKHq99TQ6jUauiCUkdRSdas=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      inherit ffmpeg;
    })
  ];

  propagatedBuildInputs = [
    numpy
    torch
    tqdm
    more-itertools
    transformers
    ffmpeg-python
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
  ];

  meta = with lib; {
    description = "General-purpose speech recognition model";
    homepage = "https://github.com/openai/whisper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

