{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  rustPlatform,
  cargo,
  wasm-component-ld,
  llvmPackages,
  go,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vercel";
  version = "58.4.4";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "vercel";
    tag = "vercel@${finalAttrs.version}";
    hash = "sha256-wjY6Q07ioJp9AkGYfAH3sqMVLyj6YJ4WA8Y7qzP9K/4=";
  };

  pnpmWorkspaces = [ "vercel..." ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-LUF89cHURh5Z4KjkVeyRaOTzbJyQl7RLCLEqSmCZzqI=";
  };

  cargoRoot = "packages/python-analysis";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-ZHdPWcXe6r3HnYYQJpwW/vd1TvKeKpUOf/TcJ/2v378=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    rustPlatform.cargoSetupHook
    (callPackage ./rustc-wasip2.nix { })
    cargo
    wasm-component-ld
    llvmPackages.lld
    # ipc-proxy cross-compiles Linux helpers; without Go it downloads a toolchain.
    go
    makeWrapper
  ];

  postPatch = ''
    # Nix supplies Cargo and its target standard library without rustup.
    substituteInPlace packages/python-analysis/scripts/build-wasm.mjs \
      --replace-fail 'checkToolchain();' "" \
      --replace-fail "['build', '--target'" "['build', '--offline', '--locked', '--target'"
  '';

  # SENTRY_DSN is intentionally unset so the CLI does not report errors to Sentry.
  env = {
    # Nixpkgs Rust omits the bundled linker for Wasm components.
    CARGO_TARGET_WASM32_WASIP2_LINKER = "wasm-component-ld";
    # Use the packaged Go version instead of downloading the version in go.mod.
    GOTOOLCHAIN = "local";
    TURBO_TELEMETRY_DISABLED = "1";
  };

  buildPhase = ''
    runHook preBuild
    export GOCACHE="$TMPDIR/go-cache"
    node utils/gen.js
    pnpm --filter=vercel... --recursive run build
    runHook postBuild
  '';

  # Run sandbox-compatible tests for Python analysis and bundled builders.
  # The full suite needs network access, credentials, or external runtimes.
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    pnpm --filter=@vercel/python-analysis exec vitest run \
      --reporter=basic --config ../../vitest.config.mts test/semantic.test.ts test/pep508.test.ts
    pnpm --filter=vercel exec vitest run --config vitest.config.mts \
      --reporter=basic test/unit/scripts/pin-builders.test.ts
    # The other builder-import tests install packages from the npm registry.
    pnpm --filter=vercel exec vitest run --config vitest.config.mts \
      --reporter=basic test/unit/util/build/import-builders.test.ts \
      -t 'should import built-in Builders'
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    node packages/cli/scripts/pin-builders.mjs pin
    pnpm config set --location=project injectWorkspacePackages true
    pnpm --filter=vercel --prod deploy --offline "$out/lib/vercel"
    mkdir -p "$out/bin"
    # Project builds need node/npm on PATH; updates are managed by Nix.
    makeWrapper ${lib.getExe nodejs} "$out/bin/vercel" \
      --add-flags "$out/lib/vercel/dist/vc.js" \
      --suffix PATH : ${lib.makeBinPath [ nodejs ]} \
      --set NO_UPDATE_NOTIFIER 1
    ln -s vercel "$out/bin/vc"
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  postInstallCheck = ''
    "$out/bin/vercel" --help > /dev/null
    "$out/bin/vc" --version
    node ${./install-check.cjs} ${stdenv.shell}
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^vercel@(.*)$" ];
    };
  };

  meta = {
    description = "Command-line interface for Vercel";
    homepage = "https://vercel.com/docs/cli";
    changelog = "https://github.com/vercel/vercel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    # Rollup, Rolldown, @napi-rs/keyring and oxc-transform ship native addons.
    # undici and source-map ship precompiled Wasm.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
      binaryBytecode
    ];
    mainProgram = "vercel";
    maintainers = with lib.maintainers; [ lmdevv ];
    # Nixpkgs 26.11 no longer supports x86_64-darwin.
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
