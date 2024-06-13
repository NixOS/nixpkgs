{ fetchFromGitHub
, rustPlatform
, lib
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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    actual="$($out/bin/wstunnel --version)"
    expected="${pname} ${version}"
    echo "Check that 'wstunnel --version' returns: $expected"
    if [[ "$actual" != "$expected" ]]; then
      echo "'wstunnel --version' returned: $actual"
      exit 1
    fi
    runHook postInstallCheck
  '';

  meta = {
    description = "Tunnel all your traffic over Websocket or HTTP2 - Bypass firewalls/DPI";
    homepage = "https://github.com/erebe/wstunnel";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rvdp neverbehave ];
    mainProgram = "wstunnel";
  };
}
