{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llguidance";
  version = "0.6.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "llguidance";
    tag = "v${version}";
    hash = "sha256-7XtGKqkAk6ZvWPSswLe07FaB/RYKZEi+3Lp+GBIP0OI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-WbPTnB1Mv9HYOrMnDhayO2V4zkuwVH/C17MdkFy57Rc=";
  };

  build-system = [
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

  disabledTests =
    [
      # Require internet access (https://huggingface.co)
      "test_grammar"
      "test_par_grammar"
      "test_par_errors"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # torch._inductor.exc.CppCompileError: C++ compile error
      # OpenMP support not found.
      "test_mask_data_torch"
    ];

  disabledTestPaths = [
    # Require internet access (https://huggingface.co)
    "scripts/tokenizer_test.py"
  ];

  # As dynamo is not supported on Python 3.13+, no successfull tests remain.
  doCheck = pythonOlder "3.13";

  meta = {
    description = "Super-fast Structured Outputs";
    homepage = "https://github.com/guidance-ai/llguidance";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
