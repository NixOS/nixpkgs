{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  version = "0.3.1";
  pname = "transmission-rss";

  src = fetchFromGitHub {
    owner = "herlon214";
    repo = pname;
    rev = "5bbad7a81621a194b7a8b11a56051308a7ccbf06";
    sha256 = "sha256-SkEgxinqPA9feOIF68oewVyRKv3SY6fWWZLGJeH+r4M=";
  };

  cargoPatches = [ ./update-cargo-lock-version.patch ];

  cargoHash = "sha256-QNMdqoxxY8ao2O44hJxZNgLrPwzu9+ieweTPc7pfFY4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Add torrents to transmission based on RSS list";
    homepage = "https://github.com/herlon214/transmission-rss";
    maintainers = with maintainers; [ icewind1991 ];
    license = licenses.mit;
    mainProgram = "transmission-rss";
  };
}
