{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,

  # build-system
  cmake,
  pybind11,
  setuptools,

  # dependencies
  sentencepiece,
  tiktoken,
  tokenizers,

  # tests
  pytestCheckHook,
  transformers,
}:

let
  # https://github.com/meta-pytorch/tokenizers/blob/v<VERSION>/CMakeLists.txt#L174-L175
  pybind11-src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    tag = "v2.13.6";
    hash = "sha256-SNLdtrOjaC3lGHN9MAqTf51U9EzNKQLyTMNPe0GcdrU=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "pytorch-tokenizers";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "tokenizers";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-la1PH8KT6iWYjvwBNYcQu5KwRS1/6H7SX5Vu6bpD+vg=";
  };

  patches = [
    (replaceVars ./dont-fetch-pybind11.patch {
      pybind11 = pybind11-src;
    })
    # error: ‘uint32_t’ does not name a type
    ./add-missing-cstdint-sentencepiece.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pip>=23",' "" \
      --replace-fail '"pytest",' ""
  '';

  build-system = [
    cmake
    pybind11
    setuptools
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    sentencepiece
    tiktoken
    tokenizers
  ];

  pythonImportsCheck = [
    "pytorch_tokenizers"
    "pytorch_tokenizers.pytorch_tokenizers_cpp"
  ];

  preCheck = ''
    rm -rf pytorch_tokenizers
  '';

  nativeCheckInputs = [
    pytestCheckHook
    transformers
  ];

  disabledTestPaths = [
    # Require downloading models from huggingface
    "test/test_hf_tokenizer.py"
  ];

  meta = {
    description = "C++ implementations for various tokenizers (sentencepiece, tiktoken, etc.)";
    homepage = "https://github.com/meta-pytorch/tokenizers";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
