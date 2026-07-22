{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  gmpy2,
  pytestCheckHook,

  pytest,
  pytest-cov,

  # Dependencies
  numpy,
  torch, # ==1.7.0
  onnxruntime,
  requests,
  tqdm,
  transformers,
  pandas,
}:

buildPythonPackage (finalAttrs: {
  pname = "g2pw";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GitYCC";
    repo = "g2pW";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1t2bIJKvuu0MN7YRNa3s8rg8Lxp8Yz054+wI/6HHles=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    torch # ==1.7.0
    onnxruntime
    requests
    tqdm
    transformers
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    numpy
  ];

  disabledTests = [ "test_forward" ];

  meta = {
    description = "Chinese Mandarin Grapheme-to-Phoneme Converter";
    homepage = "https://github.com/GitYCC/g2pW";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
})
