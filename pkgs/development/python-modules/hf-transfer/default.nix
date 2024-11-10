{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cargo,
  pkg-config,
  rustPlatform,
  rustc,

  # buildInputs
  openssl,
  stdenv,
  darwin,
  libiconv,
}:

buildPythonPackage rec {
  pname = "hf-transfer";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "hf_transfer";
    rev = "refs/tags/v${version}";
    hash = "sha256-Uh8q14OeN0fYsywYyNrH8C3wq/qRjQKEAIufi/a5RXA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-I4APdz1r2KJ8pTfKAg8g240wYy8gtMlHwmBye4796Tk=";
  };

  build-system = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
      libiconv
    ];

  pythonImportsCheck = [ "hf_transfer" ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "High speed download python library";
    homepage = "https://github.com/huggingface/hf_transfer";
    changelog = "https://github.com/huggingface/hf_transfer/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
