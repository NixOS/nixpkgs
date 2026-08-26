{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  pkg-config,
  protobuf,
  cmake,
  cacert,
  geos,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

let
  pnpm = pnpm_11;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "trailbase";
  version = "0.123.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "trailbaseio";
    repo = "trailbase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M617YtAiagUV35iUhsD7elwU738GAEIWy+wbxD/Mi5s=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-d6U4VzcctFyWclnuQZePCu6DLB79cWQZY9Mz9kDioeI=";

  patches = [ ./skip-pnpm-install.patch ];

  # Skip cargo's workspace-wide pnpm install; pnpmConfigHook already did it.
  env.TRAILBASE_SKIP_PNPM_INSTALL = "1";

  # Package plus its workspace dependencies:
  # https://pnpm.io/filtering#--filter-package_name-1
  pnpmWorkspaces = [ "trailbase-admin-ui..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-CaxLi1RZlx4MlPZzAGe1g/PBdZiWtHst0xQPGVlLbNk=";
  };

  # wasmtime's cargo-auditable build is broken:
  # https://github.com/rust-secure-code/cargo-auditable/issues/124
  auditable = false;

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    nodejs
    pnpm
    pnpmConfigHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [ geos ];

  postPatch = ''
    # `trail --version` prints the git tag. fetchFromGitHub has no .git.
    substituteInPlace crates/build/src/version.rs \
      --replace-fail 'get_output("git", &["describe", "--tags", "--match=v*", "--long"])' \
      'Some("v${finalAttrs.version}".to_string())'
  '';

  cargoBuildFlags = [
    "--bin"
    "trail"
  ];

  # test_utils is behind `#[cfg(debug_assertions)]`.
  checkType = "debug";

  # reqwest/rustls refuses to build a client without a CA bundle,
  # even for the local HTTP OAuth mock.
  nativeCheckInputs = [ cacert ];

  # Full client e2e needs a seeded depot, WASM guests, and email.
  # The NixOS test covers login + record CRUD against the packaged server.
  checkFlags = [ "--skip=client_integration_test" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = {
      inherit (nixosTests) trailbase;
    };
    services.default = {
      imports = [ (lib.modules.importApply ./service.nix { }) ];
      trailbase.package = lib.mkDefault finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Single-executable Firebase alternative with type-safe APIs, auth, and an admin UI";
    homepage = "https://trailbase.io";
    changelog = "https://github.com/trailbaseio/trailbase/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.osl3;
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
    mainProgram = "trail";
    platforms = lib.platforms.unix;
  };
})
