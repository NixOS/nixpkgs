{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zerostack";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "gi-dellav";
    repo = "zerostack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hwUZCy+rB/jtGpo96vm3yDAKoNB481pG3vkp4O/yYsI=";
  };

  cargoHash = "sha256-QK/zk1Z1ZJ/pTAH4dzrsAkIPUyT5+SaAkmVZVkVZ3KU=";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    # Required by the aws-lc-sys build script (rustls TLS backend pulled in
    # transitively via reqwest/rig). pkg-config is used by the *-sys crates
    # to probe for system libraries.
    cmake
    pkg-config
  ];

  # cmake here is only invoked from a crate build script, not to configure
  # this project, so the cmake setup-hook's configurePhase must be disabled.
  dontUseCmakeConfigure = true;

  # Upstream's .cargo/config.toml pins the mold linker via
  # -fuse-ld=mold, which isn't present in the nixpkgs build sandbox.
  # It's only a local dev-speed optimization, so drop the override and
  # use the default toolchain.
  postPatch = ''
    rm .cargo/config.toml
  '';

  passthru.updateScript = nix-update-script {
    # Upstream also publishes -rcN prerelease tags (e.g. v1.4.0-rc2); only
    # track stable vX.Y.Z releases.
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Minimalistic coding agent optimized for memory footprint and performance";
    homepage = "https://github.com/gi-dellav/zerostack";
    changelog = "https://github.com/gi-dellav/zerostack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "zerostack";
    platforms = lib.platforms.unix;
  };
})
