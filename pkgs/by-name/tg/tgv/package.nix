{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tgv";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zeqianli";
    repo = "tgv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i+ODCIpR7RpcC4y7c9hbH/mBilvZZRhu9/hJwUcdoNI=";
  };

  cargoHash = "sha256-+VggRnjIq+nB91pB5LEbPAsSigXJEV3IcBEQQnWjKRI=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  checkFlags = [
    # requires network access
    "--skip=tests::download_integration_test"
    "--skip=tests::integration_test::case_1"
    "--skip=tests::integration_test::case_2"
    "--skip=tests::integration_test::case_3"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal genome explorer";
    homepage = "https://github.com/zeqianli/tgv";
    changelog = "https://github.com/zeqianli/tgv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      idlip
      mvs
    ];

    mainProgram = "tgv";
  };
})
