{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

let
  version = "10.1.6";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    rev = "v${version}";
    hash = "sha256-ufssj7m5mly2B33e1DWY2e6AH0zTPh3SozYc663QjJ4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fastwebsockets-0.8.0" = "sha256-eqtCh9fMOG2uvL/GLUVXNiSB+ovYLc/Apuq9zssn8hU=";
    };
  };

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
