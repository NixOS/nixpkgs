{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wstunnel-rust";
  version = "9.2.2";

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    rev = "v${version}";
    hash = "sha256-uJ0VHctw9Aip+WgJEr4K0brSj1dRd17kA+ayCI72DHg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fast-socks5-0.9.1" = "sha256-FSSpJx/ikFT06u9Xbmhtg2Zh3uPTfGpAhhhAkz0oKK0=";
      "fastwebsockets-0.6.0" = "sha256-y3Z9/a59kOQnUcBS7qWkb2MlRlEIwlF/5am8Za5O7a0=";
    };
  };

  checkFlags = [
    # failed to list docker networks
    "--skip=tcp::tests::test_proxy_connection"
  ];

  meta = with lib; {
    description = "Tunnel all your traffic over Websocket or HTTP2 - Bypass firewalls/DPI";
    longDescription = ''
      Most of the time when you are using a public network, you are
      behind some kind of firewall or proxy. One of their purpose is
      to constrain you to only use certain kind of protocols and consult
      only a subset of the web. Nowadays, the most widespread protocol
      is http and is de facto allowed by third party equipment.
      Wstunnel uses the websocket protocol which is compatible with http
      in order to bypass firewalls and proxies. Wstunnel allows you to
      tunnel whatever traffic you want and access whatever resources/site
      you need.
      Note that this is the Rust rewrite of the original Haskell wstunnel.
    '';
    homepage = "https://github.com/erebe/wstunnel";
    license = licenses.bsd3;
    mainProgram = "wstunnel";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
