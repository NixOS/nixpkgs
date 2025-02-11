{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

let
  version = "10.1.9";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    tag = "v${version}";
    hash = "sha256-39VPPPBKUhl17PJBa7wJi0H4jghTRjy9cFgihgK+mFE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3+vq/IJ526t7UQ6FcrTKOD1umUD07amCa3b0myfbxrI=";

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
