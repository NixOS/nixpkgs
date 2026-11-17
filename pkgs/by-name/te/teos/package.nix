{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  rustfmt,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "teos";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "talaia-labs";
    repo = "rust-teos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UrzH9xmhVq12TcSUQ1AihCG1sNGcy/N8LDsZINVKFkY=";
  };

  cargoHash = "sha256-lod5I94T4wGwXEDtvh2AyaDYM0byCfaSBP8emKV7+3M=";

  buildAndTestSubdir = "teos";

  nativeBuildInputs = [
    protobuf
    rustfmt
  ];

  passthru.updateScript = ./update.sh;

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/talaia-labs/rust-teos";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seberm ];
    description = "Lightning watchtower compliant with BOLT13, written in Rust";
  };
})
