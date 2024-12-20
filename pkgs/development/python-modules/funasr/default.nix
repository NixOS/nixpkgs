{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  editdistance,
  hydra-core,
  jaconv,
  jamo,
  jieba,
  kaldiio,
  librosa,
  modelscope,
  onnx,
  onnxconverter-common,
  oss2,
  pydub,
  pytorch-wpe,
  pyyaml,
  requests,
  scipy,
  sentencepiece,
  soundfile,
  tensorboardx,
  torch-complex,
  torchaudio,
  tqdm,
  umap-learn,
}:
buildPythonPackage rec {
  pname = "funasr";
  version = "0-unstable-2024-12-13";
  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "FunASR";
    rev = "7263fb08e9170e90e67cb9b48884cc6a35cb3b62";
    hash = "sha256-iSOlvjs5/cZXPmaHzY7miL1PwFLgb/kJczLKjSkPxBQ=";
  };

  propagatedBuildInputs = [
    editdistance
    hydra-core
    jaconv
    jamo
    jieba
    kaldiio
    librosa
    modelscope
    onnx
    onnxconverter-common
    oss2
    pydub
    pytorch-wpe
    pyyaml
    requests
    scipy
    sentencepiece
    soundfile
    tensorboardx
    torch-complex
    torchaudio
    tqdm
    umap-learn
  ];

  postPatch = ''
    substituteInPlace "setup.py" \
      --replace-fail '"pytest-runner",' ""
  '';

  pythonImportsCheck = [ "funasr" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Fundamental End-to-End Speech Recognition Toolkit and Open Source SOTA Pretrained Models";
    homepage = "https://www.funasr.com/";
    license = with lib.licenses; [ mit ];
  };
}
