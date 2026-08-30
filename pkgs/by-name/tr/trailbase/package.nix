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
  version = "0.32.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "trailbaseio";
    repo = "trailbase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b+HtxTg9UN5uvix9FkzRnRr7eP6dLVGz0v8UPqeTqaM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-RUbP49jXJj8UC2Sww0UlH8uyEpkshi2gewNqZ7XYeG4=";

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
    hash = "sha256-ue2hqveVMWEIB9GUD3NCohPO2VW2G+17L/OqLhz6UeE=";
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
    updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };
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
