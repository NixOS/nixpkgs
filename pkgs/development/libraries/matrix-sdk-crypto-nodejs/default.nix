{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  napi-rs-cli,
  nodejs,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "matrix-sdk-crypto-nodejs";
  version = "0.1.0-beta.11";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-rust-sdk-crypto-nodejs";
    rev = "v${version}";
    hash = "sha256-vDLbpKNrvySi5hYBYGihZoRPWPQb2dW2FV+7lHhe8sc=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo-default.lock;
    outputHashes = {
      "matrix-sdk-base-0.6.1" = "sha256-clQK+gSIacejaq5MqDU0mvTcmpopvk9W1raAaXKjCNE=";
      "ruma-0.8.2" = "sha256-ZlevGTGL/DQVAYeR078I0cT/V1kaubhORgt1cZUhBqM=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    napi-rs-cli
    nodejs
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  buildPhase = ''
    runHook preBuild

    npm run release-build --offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local -r outPath="$out/lib/node_modules/@matrix-org/${pname}"
    mkdir -p "$outPath"
    cp package.json index.js index.d.ts matrix-sdk-crypto.*.node "$outPath"

    runHook postInstall
  '';

  meta = with lib; {
    description = "No-network-IO implementation of a state machine that handles E2EE for Matrix clients";
    homepage = "https://github.com/matrix-org/matrix-rust-sdk/tree/${src.rev}/bindings/matrix-sdk-crypto-nodejs";
    license = licenses.asl20;
    maintainers = with maintainers; [ winter ];
    inherit (nodejs.meta) platforms;
  };
}
