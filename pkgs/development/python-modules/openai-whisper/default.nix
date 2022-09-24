{ lib
, fetchFromGitHub
, buildPythonPackage

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
  version = "unstable-2022-09-23";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "8cf36f3508c9acd341a45eb2364239a3d81458b9";
    hash = "sha256-2RH8eM/SezqFJltelv5AjQEGpqXm980u57vrlkTEUvQ=";
  };

  postPatch = ''
    # Rely on the ffmpeg path already patched into the ffmpeg-python library
    substituteInPlace whisper/audio.py \
      --replace 'run(cmd="ffmpeg",' 'run('
  '';

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

  checkInputs = [
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

