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
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "hf_transfer";
    tag = "v${version}";
    hash = "sha256-mcU3YuJVfuwBvtLfqceV3glcJcpjSX7M3VjvbvLCxZg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-O4aKqVSShFpt8mdZkY3WV55j9CIczRSRkIMC7dJoGv0=";
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
