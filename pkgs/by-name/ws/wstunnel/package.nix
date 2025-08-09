{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

let
  version = "10.2.0";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    tag = "v${version}";
    hash = "sha256-j4JJWa8y9fAiCcnFQY9u67XPb6m9cY7Q6p0cxHPQQzc=";
  };

  cargoHash = "sha256-9YAjC5XBRcXYmQoYs9FoxbVtFoM9hvAweLfrodtj+bw=";

  cargoBuildFlags = [ "--package wstunnel-cli" ];

  nativeBuildInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
    changelog = "https://github.com/erebe/wstunnel/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      raylas
      rvdp
      neverbehave
    ];
    mainProgram = "wstunnel";
  };
}
