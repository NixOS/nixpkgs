{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  curl,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "wrangler";
    rev = "v${version}";
    sha256 = "sha256-GfuU+g4tPU3TorzymEa9q8n4uKYsG0ZTz8rJirGOLfQ=";
  };

  cargoHash = "sha256-MJFXcmRzvzDJ8cd0WdcNiHr3Wxgp/hKO1xKRfmbxRLA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
    libiconv
  ];

  OPENSSL_NO_VENDOR = 1;

  # tries to use "/homeless-shelter" and fails
  doCheck = false;

  meta = with lib; {
    description = "CLI tool designed for folks who are interested in using Cloudflare Workers";
    mainProgram = "wrangler";
    homepage = "https://github.com/cloudflare/wrangler";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
