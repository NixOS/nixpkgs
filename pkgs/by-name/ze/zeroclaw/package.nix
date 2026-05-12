{
  lib,
  buildNpmPackage,
  rustPlatform,
  fetchFromGitHub,
  cargo,
  rustc,
  pkg-config,
  protobuf,
  sqlite,
  writableTmpDirAsHomeHook,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "zeroclaw-labs";
    repo = "zeroclaw";
    tag = "v${version}";
    hash = "sha256-hVHfsBw3u0CLWAbmizLA9ZrB+3B0qBIrSUuzsyChwW0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-6MGIJsaqRp3k/ysjdu6BE2iM2sehERQR+QoSqiThSpg=";
  };

  web = buildNpmPackage {
    pname = "zeroclaw-web";
    inherit version src cargoDeps;

    sourceRoot = "${src.name}/web";
    cargoRoot = "..";

    npmDepsHash = "sha256-DVL9kov8y1Eh3BM2Rpw+KbTDL6/AvT/epknM2X/Gf3E=";

    nativeBuildInputs = [
      cargo
      rustc
      rustPlatform.cargoSetupHook
      pkg-config
      protobuf
    ];

    buildInputs = [
      sqlite
    ];

    postUnpack = ''
      chmod -R u+w ${src.name}
    '';

    preBuild = ''
      pushd ..
      mkdir -p web/dist && touch web/dist/index.html
      cargo build --release -p xtask --bin web
      ./target/release/web gen-api || true
      popd
      npx openapi-typescript ../target/openapi.json -o src/lib/api-generated.ts
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  pname = "zeroclaw";
  inherit version src cargoDeps;

  postPatch = ''
    rm -rf web/dist
    ln -s ${web} web/dist
  '';

  postInstall = ''
    mkdir -p $out/bin/web
    ln -s ${web} $out/bin/web/dist
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    sqlite
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    gitMinimal
  ];

  checkFlags = [
    "--skip=memory::lucid::tests::failure_cooldown_avoids_repeated_lucid_calls"
    "--skip=memory::lucid::tests::recall_handles_lucid_cold_start_delay_within_timeout"
    "--skip=memory::lucid::tests::recall_merges_lucid_and_local_results"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, small, and fully autonomous AI assistant infrastructure — deploy anywhere, swap anything";
    homepage = "https://github.com/zeroclaw-labs/zeroclaw";
    changelog = "https://github.com/zeroclaw-labs/zeroclaw/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "zeroclaw";
  };
}
