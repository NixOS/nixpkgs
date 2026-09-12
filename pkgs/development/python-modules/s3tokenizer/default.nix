{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  numpy,
  onnx,
  setuptools,
  torch,
  torchaudio,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "s3tokenizer";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xingchensong";
    repo = "S3Tokenizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iwOghxMhIS1b+esweiVNj3a0Y1eIxxATuBSqFzN/t3A=";
  };

  # Do not go over slow modelscope mirror
  postPatch = ''
    substituteInPlace s3tokenizer/__init__.py \
      --replace-fail "https://www.modelscope.cn/models/iic/cosyvoice-300m/" "https://huggingface.co/FunAudioLLM/CosyVoice-300M/" \
      --replace-fail "https://www.modelscope.cn/models/iic/CosyVoice2-0.5B/" "https://huggingface.co/FunAudioLLM/CosyVoice2-0.5B/" \
      --replace-fail "https://www.modelscope.cn/models/FunAudioLLM/Fun-CosyVoice3-0.5B-2512/" "https://huggingface.co/FunAudioLLM/Fun-CosyVoice3-0.5B-2512/"
  '';

  build-system = [
    setuptools
  ];

  pythonRemoveDeps = [
    "pre-commit"
  ];

  dependencies = [
    einops
    numpy
    onnx
    torch
    torchaudio
    tqdm
  ];

  # requires downloading 4 model snapshots each ~500MB
  doCheck = false;

  pythonImportsCheck = [ "s3tokenizer" ];

  meta = {
    description = "Reverse Engineering of Supervised Semantic Speech Tokenizer (S3Tokenizer) proposed in CosyVoice";
    homepage = "https://github.com/xingchensong/S3Tokenizer";
    changelog = "https://github.com/xingchensong/S3Tokenizer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
