{
  lib,
  rustPlatform,
  teos,
  pkg-config,
  protobuf,
  rustfmt,
  openssl,
  stdenv, # for meta.broken
}:

rustPlatform.buildRustPackage {
  pname = "teos-watchtower-plugin";
  inherit (teos) version src;

  cargoHash = "sha256-lod5I94T4wGwXEDtvh2AyaDYM0byCfaSBP8emKV7+3M=";

  buildAndTestSubdir = "watchtower-plugin";

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustfmt
  ];

  buildInputs = [
    openssl
  ];

  __darwinAllowLocalNetworking = true;

  meta = teos.meta // {
    # last successful hydra build on darwin was in 2024
    broken = stdenv.hostPlatform.isDarwin;
    description = "Lightning watchtower plugin for clightning";
    mainProgram = "watchtower-client";
  };
}
