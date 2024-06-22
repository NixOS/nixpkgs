{ lib
, fetchFromGitHub
, rustPlatform
, testers
, wstunnel
, nixosTests
}:

let
  version = "9.7.0";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    rev = "v${version}";
    hash = "sha256-8bLccR6ZmldmrvjlZKFHEa4PoLzyUcLkyQbwSrJjoyY=";
  };

  cargoHash = "sha256-IAq7Fyr6Ne1Bq18WfqBoppel9FOWSs8PkiXKMwcJ26c=";

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
