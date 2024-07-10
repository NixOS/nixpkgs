{ lib
, fetchFromGitHub
, rustPlatform
, testers
, wstunnel
, nixosTests
}:

let
  version = "9.7.2";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    rev = "v${version}";
    hash = "sha256-5hpkY8MoSo59KmhXsPuLCmWq4KaUzuHBpesQMtgn7hw=";
  };

  cargoHash = "sha256-kv+DX98SjI3m2CdM4RHoMMISZyrFmlhlSaBor0dFUSE=";

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
