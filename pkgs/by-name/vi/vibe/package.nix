{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vibe";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kexi";
    repo = "vibe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p3lZVlsHT+wifoqQIO81jIh0OJywwwTjt/7UbhIaw5w=";
  };

  # Cargo workspace and lockfile live in the rust/ subdirectory.
  cargoRoot = "rust";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-ZusHniKic9AbZk5USbB6eAE8OPVhM9+GMm5JKToWlsU=";

  # Build only the shipped binary crate (mirrors `cargo build -p vibe`).
  cargoBuildFlags = [
    "-p"
    "vibe"
  ];

  # Surface the packaging origin to build.rs. VIBE_BUILD_COMMIT is deliberately
  # left unset: there is no git in the sandbox and build.rs already falls back to
  # an empty commit, so the embedded version stays "2.0.0".
  env = {
    VIBE_BUILD_DISTRIBUTION = "nixpkgs";
    VIBE_BUILD_ENV = "nixpkgs";
  };

  # rustls/aws-lc-rs links libgcc_s at runtime on Linux; buildRustPackage runs
  # autoPatchelfHook there and needs the shared lib present.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  # The workspace test suite needs git, a populated worktree, and filesystem
  # fixtures unavailable in the Nix sandbox; tests run upstream in CI instead.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git worktree helper CLI";
    homepage = "https://github.com/kexi/vibe";
    changelog = "https://github.com/kexi/vibe/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "vibe";
    maintainers = with lib.maintainers; [ kexi ];
    platforms = lib.platforms.unix;
  };
})
