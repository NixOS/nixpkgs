{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wstunnel";
  version = "10.5.2";

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CsXzcQ4rd2NTjDJjsi5U3Hes2D98HQ8K6/AmPRSLkbM=";
  };

  cargoHash = "sha256-/JRfgJpg5FjkjWUYDe/ln3rMv0ISQy0AEdcZaPmLBDg=";

  cargoBuildFlags = [ "--package wstunnel-cli" ];

  nativeBuildInputs = [ versionCheckHook ];
  doInstallCheck = true;

  checkFlags = [
    # Tries to launch a test container
    "--skip=tcp::tests::test_proxy_connection"
    "--skip=protocols::tcp::server::tests::test_proxy_connection"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      nixosTest = nixosTests.wstunnel;
    };
  };

  meta = {
    description = "Tunnel all your traffic over Websocket or HTTP2 - Bypass firewalls/DPI";
    homepage = "https://github.com/erebe/wstunnel";
    changelog = "https://github.com/erebe/wstunnel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      raylas
      rvdp
      neverbehave
    ];
    mainProgram = "wstunnel";
  };
})
