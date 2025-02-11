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
  version = "0.2.0-beta.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-rust-sdk-crypto-nodejs";
    rev = "v${version}";
    hash = "sha256-g86RPfhF9XHpbXhHRbyhl920VazCrQyRQrYV6tVCHy4=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "matrix-sdk-base-0.7.0" = "sha256-nCiG4T/MB7gvGrmadKOEbh8+54081PHee9Bm8oY/nl0=";
      "ruma-0.10.1" = "sha256-Yc5RKk4aRjNIoQsMl30fFehTDCkRO9VvenAvLoVHzXo=";
      "vodozemac-0.6.0" = "sha256-jJgrJJ0SFcy2oRRZ3ubuKnM2pLO8Tx6NyXordWJjz8o=";
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
    homepage = "https://github.com/matrix-org/matrix-rust-sdk-crypto-nodejs";
    changelog = "https://github.com/matrix-org/matrix-rust-sdk-crypto-nodejs/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      winter
      dandellion
    ];
    inherit (nodejs.meta) platforms;
  };
}
