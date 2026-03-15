{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  maturin,
  pkg-config,
  openssl,
  krb5-c,
}:
buildPythonPackage (finalAttrs: {
  pname = "connectorx";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sfu-db";
    repo = "connector-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gdd+YwPmm2h11VOVe7ei38mwEEjsdCfK7uTDNeY2UVY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src sourceRoot;
    hash = "sha256-jYHaVvjAo9MfyWcK3KSrtlSik4K23q4U5UMoPkEKO/E=";
  };

  sourceRoot = "source/connectorx-python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    bindgenHook
    pkg-config
    krb5-c.dev
  ];

  build-system = [
    maturin
  ];

  OPENSSL_NO_VENDOR = "1";
  OPENSSL_DIR = openssl.out;
  OPENSSL_INCLUDE_DIR = "${lib.getDev openssl}/include";

  NIX_CFLAGS_COMPILE = "-I ${lib.getDev krb5-c}/include";
  NIX_CFLAGS_LINK = "-L ${lib.getLib krb5-c}/lib";

  meta = {
    homepage = "https://github.com/sfu-db/connector-x";
    changelog = "https://github.com/sfu-db/connector-x/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
})
