{ fetchFromGitHub
, rustPlatform
, lib
}:

rustPlatform.buildRustPackage rec {
  pname = "wstunnel";
  version = "9.6.2";

  src = fetchFromGitHub {
    owner = "erebe";
    repo  = "wstunnel";
    rev = "v${version}";
    hash = "sha256-0r+8C8Gf3/s3opzplzc22d9VVp39FtBq1bYkxlmtqjg=";
  };

  cargoHash = "sha256-hHVxa7Ihmuuf26ZSzGmrHA2RczhzXtse3h1M4cNCvhw=";

  checkFlags = [
    # make use of network connection
    "--skip=tcp::tests::test_proxy_connection"
  ];

  meta = {
    description = "Tunneling program over websocket protocol";
    mainProgram = "wstunnel";
    homepage    = "https://github.com/erebe/wstunnel";
    license     = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ neverbehave ];
    platforms   = lib.platforms.linux;
  };
}
