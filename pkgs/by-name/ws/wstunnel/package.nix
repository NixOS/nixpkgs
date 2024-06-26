{ lib
, fetchFromGitHub
, rustPlatform
, testers
, wstunnel
, nixosTests
}:

let
  version = "9.7.1";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    rev = "v${version}";
    hash = "sha256-VJllyvTlHlyYhzth6tVzqVe8EPfHdXrcrDmtrS16aMM=";
  };

  cargoHash = "sha256-sg/tE8D/cNeMliJr7JIstq36gg/mhYM6n8ye2Y2biq0=";

  checkFlags = [
    # Tries to launch a test container
    "--skip=tcp::tests::test_proxy_connection"
  ];

  passthru.tests = {
    version = testers.testVersion { package = wstunnel; };
    nixosTest = nixosTests.wstunnel;
  };

  meta = {
    description = "Tunnel all your traffic over Websocket or HTTP2 - Bypass firewalls/DPI";
    homepage = "https://github.com/erebe/wstunnel";
    changelog = "https://github.com/erebe/wstunnel/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rvdp neverbehave ];
    mainProgram = "wstunnel";
  };
}
