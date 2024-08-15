{ lib
, fetchFromGitHub
, rustPlatform
, testers
, wstunnel
, nixosTests
}:

let
  version = "9.7.4";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    rev = "v${version}";
    hash = "sha256-OFm0Jk06Mxzr4F7KrMBGFqcDSuTtrMvBSK99bbOgua4=";
  };

  cargoHash = "sha256-JMRcXuw6AKfwViOgYAgFdSwUeTo04rEkKj+t+W8wjGI=";

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
