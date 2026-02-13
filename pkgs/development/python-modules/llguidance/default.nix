{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # nativeBuildInputs
  cargo,
  pkg-config,
  rustPlatform,
  rustc,

  # buildInputs
  oniguruma,
  openssl,

  # tests
  pytestCheckHook,
  torch,
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "llguidance";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "llguidance";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dLX01+8R6SbirFda10dufhMxARSVIXj2y8xIj95Od7A=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-fmQ+A6spWUR0bY5LG+MGW9uTFmYJPQjx8tGxkFXttgc=";
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [
    oniguruma
    openssl
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  pythonImportsCheck = [
    "llguidance"
    "llguidance._lib"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
    transformers
  ];

  # Prevent python from loading the package from $src instead of the $out
  preCheck = ''
    rm -r python/llguidance
  '';

  disabledTests = [
    # Require internet access (https://huggingface.co)
    "test_grammar"
    "test_incomplete_tokenizer"
    "test_par_errors"
    "test_par_grammar"
    "test_tokenize_partial_basic"
    "test_tokenize_partial_docs"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # torch._inductor.exc.CppCompileError: C++ compile error
    # OpenMP support not found.
    "test_mask_data_torch"
  ];

  disabledTestPaths = [
    # Require internet access (https://huggingface.co)
    "python/torch_tests/test_hf.py"
    "python/torch_tests/test_llamacpp.py"
    "python/torch_tests/test_tiktoken.py"
    "scripts/tokenizer_test.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # RuntimeError: torch.compile is not supported on Python 3.14+
    "python/torch_tests/test_bitmask.py"
  ];

  meta = {
    description = "Super-fast Structured Outputs";
    homepage = "https://github.com/guidance-ai/llguidance";
    changelog = "https://github.com/guidance-ai/llguidance/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
