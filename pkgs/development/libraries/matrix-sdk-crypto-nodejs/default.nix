{ lib, stdenv, fetchFromGitHub
, cargo, rustPlatform, rustc, napi-rs-cli, nodejs, libiconv
}:

stdenv.mkDerivation rec {
  pname = "matrix-sdk-crypto-nodejs";
  version = "0.1.0-beta.6";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-rust-sdk";
    rev = "${pname}-v${version}";
    hash = "sha256-0oLk7yq/XELS0GkeZj7PxY3KKXfzws0djF3KmxYisY0=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ruma-0.8.2" = "sha256-bKvcElIVugj+gZZhPFPGfCqva4fo1IqW/e9gf+q/Tfw=";
      "uniffi-0.23.0" = "sha256-4WUp3PQm3ZgqHNMvz9+PBtNAeiq6m4PBViwXpQDglLk=";
      "vodozemac-0.3.0" = "sha256-tAimsVD8SZmlVybb7HvRffwlNsfb7gLWGCplmwbLIVE=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    napi-rs-cli
    nodejs
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  buildPhase = ''
    runHook preBuild

    cd bindings/${pname}
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
    description = "A no-network-IO implementation of a state machine that handles E2EE for Matrix clients";
    homepage = "https://github.com/matrix-org/matrix-rust-sdk/tree/${src.rev}/bindings/matrix-sdk-crypto-nodejs";
    license = licenses.asl20;
    maintainers = with maintainers; [ winter ];
    inherit (nodejs.meta) platforms;
  };
}
