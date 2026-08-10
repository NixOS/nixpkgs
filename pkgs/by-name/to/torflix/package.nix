{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "torflix";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "surajssc1232";
    repo = "torflix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-626us6H5DDYKoEoWQasNLdT69z9U7XfBwKY3Z7s5u1M=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # openssl crate has `vendored` feature set, but nixpkgs uses system openssl
  env.OPENSSL_NO_VENDOR = 1;

  meta = {
    description = "Stream movies and shows in your terminal — search torrents, pick a file, and start watching in seconds";
    homepage = "https://github.com/surajssc1232/torflix";
    changelog = "https://github.com/surajssc1232/torflix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ surajssc1232 ];
    mainProgram = "torflix";
    platforms = lib.platforms.linux;
  };
})
