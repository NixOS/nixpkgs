{ lib, stdenv, fetchFromGitHub, rustPlatform, napi-rs-cli, nodejs, libiconv }:

stdenv.mkDerivation rec {
  pname = "matrix-sdk-crypto-nodejs";
  version = "0.1.0-beta.2";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-rust-sdk";
    rev = "${pname}-v${version}";
    hash = "sha256-E++0tm/2d8/3zAXwovJ71uF2sxDORWyJNnA3e1Q3NLA=";
  };

  patches = [
    # This is needed because two versions of indexed_db_futures are present (which will fail to vendor, see https://github.com/rust-lang/cargo/issues/10310).
    # (matrix-sdk-crypto-nodejs doesn't use this dependency, we only need to remove it to vendor the dependencies successfully.)
    ./remove-duplicate-dependency.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-G2Um7vHinOuOx9U2BH14LAx+s/0Sxtlc9Nz6nPJfmU8=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
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
