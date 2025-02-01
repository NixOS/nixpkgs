{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  nixosTests,
  nix-update-script,
  versionCheckHook,
  apple-sdk_11,
}:

let
  version = "10.1.8";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    rev = "v${version}";
    hash = "sha256-A2c4DAHne0N96bJnjvpaI6vd2pAb4Edi45vbDWayZpo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iKGt+CjshkUE5w68ZJ9x2+3mAYQJO/oDMs/M8ARL5Po=";

  nativeBuildInputs = [ versionCheckHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_11
  ];

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
