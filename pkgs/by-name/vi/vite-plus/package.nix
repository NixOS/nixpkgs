{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vite-plus";
  version = "0.1.18";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "voidzero-dev";
    repo = "vite-plus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R/6vtdF+77n6a5woJDz8GQo6AJPkq69mNtSaS48oPNw=";
  };

  cargoPatches = [
    # The Cargo.lock has two `brush-parser` 0.3.0 entries: one from the
    # crates.io registry and one from a git source. Both have identical
    # code and dependencies, but fetchCargoVendor cannot handle duplicate
    # crate name+version pairs from different sources (FileExistsError).
    # This patch removes the git entry and redirects its sole consumer
    # (vite_shell) to the registry version.
    ./deduplicate-brush-parser.patch
  ];

  postPatch = ''
    # Upstream CI injects the release version at build time via a
    # replace-file-content tool; the source hardcodes "0.0.0".
    # Remove when https://github.com/voidzero-dev/vite-plus/pull/989 merged.
    substituteInPlace crates/vite_global_cli/Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'

    # The workspace member `packages/cli/binding` is a Node.js N-API
    # binding that depends on rolldown crates. Rolldown is not part of
    # the source tarball — it is synced externally by the justfile's
    # `sync-remote` command. Remove it and all rolldown path deps so
    # the workspace resolves without the missing directory.
    sed -i 's|, "packages/cli/binding"||' Cargo.toml
    sed -i '/^rolldown/d; /^string_wizard/d' Cargo.toml
  '';

  cargoHash = "sha256-oGWxeea+7/AUHYSGiFtUxWBH5LJLlBHEpU2jHblwIoE=";

  depsExtraArgs = {
    # Fixups applied to the vendor staging directory (FOD) before the
    # vendor creation step runs `cargo metadata` on each git dependency.
    postBuild = ''
      # --- vite-task git dependency ---
      # The vite-task workspace uses `artifact = "cdylib"` and
      # `artifact = "bin"` annotations which require the unstable
      # `-Z bindeps` cargo flag. Stable cargo's `cargo metadata`
      # rejects these, so strip them. This is safe because:
      #   - artifact deps are only used at runtime (LD_PRELOAD libs)
      #   - the vendoring step only needs to locate crate sources
      for f in $out/git/*/Cargo.toml; do
        if [ -f "$f" ]; then
          sed -i \
            -e '/artifact = /d' \
            -e 's|brush-parser = { git = "[^"]*", rev = "[^"]*" }|brush-parser = "0.3.0"|' \
            "$f"
        fi
      done

      # fspy's preload libraries (fspy_preload_unix, fspy_preload_windows)
      # use the nightly `c_variadic` feature and cannot be compiled with
      # stable rustc. They are artifact deps that fspy embeds as bytes via
      # include_bytes!(env!("CARGO_CDYLIB_FILE_...")). Remove them from
      # fspy's dep list — we provide a stub cdylib instead (see preBuild).
      # Also remove fspy_test_bin (dev-dep with artifact = "bin").
      for f in $out/git/*/crates/fspy/Cargo.toml; do
        if [ -f "$f" ]; then
          sed -i \
            -e '/fspy_preload_unix/d' \
            -e '/fspy_preload_windows/d' \
            -e '/fspy_test_bin/d' \
            "$f"
        fi
      done
    '';
  };

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ nodejs ];

  checkFlags = [
    # Fails with cdylib stub
    "--skip=tests::run_command_with_fspy_tests::"
    "--skip=test_delegate_to_local_cli_prints_node_version"
    # Require network access
    "--skip=package_manager::tests::"
    "--skip=runtime::tests::"
    "--skip=providers::node::tests::"
    # Network: resolve version from nodejs.org/dist/index.json
    "--skip=commands::env::config::tests::test_resolve_version_invalid_engines_node_falls_through_to_dev_engines"
    "--skip=commands::env::config::tests::test_resolve_version_invalid_node_version_falls_through_to_dev_engines"
    "--skip=commands::env::config::tests::test_resolve_version_invalid_node_version_falls_through_to_engines_node"
    "--skip=commands::env::config::tests::test_resolve_version_invalid_node_version_falls_through_to_lts"
    "--skip=commands::env::config::tests::test_resolve_version_latest_alias_in_node_version"
    "--skip=commands::env::exec::tests::test_execute_node_version"
    "--skip=commands::env::exec::tests::test_resolve_version_lts"
    "--skip=commands::env::exec::tests::test_resolve_version_partial"
    "--skip=commands::env::exec::tests::test_resolve_version_range"
    "--skip=commands::env::pin::tests::test_resolve_version_for_pin_exact_version"
    "--skip=commands::env::pin::tests::test_resolve_version_for_pin_partial_version"
    "--skip=commands::env::pin::tests::test_do_pin_invalidates_cache"
    # Network: require CA certificates / HTTP access
    "--skip=request::tests::"
    # Needs npm/pnpm package manager setup
    "--skip=commands::install::tests::test_install_command_with_package_json_with_package_manager"
    # Rendering test sensitive to environment
    "--skip=help::tests::render_help_doc_appends_documentation_footer"
  ];

  env = {
    # fspy uses #![feature(once_cell_try)] (stabilised API since Rust
    # 1.82, but the feature gate itself is rejected on stable).
    RUSTC_BOOTSTRAP = 1;
  };

  preBuild = ''
    # fspy embeds the fspy_preload_unix cdylib at compile time via
    #   include_bytes!(env!("CARGO_CDYLIB_FILE_FSPY_PRELOAD_UNIX"))
    # This env var is normally set by cargo's `-Z bindeps` flag. Since
    # the real fspy_preload_unix requires nightly's `c_variadic` feature,
    # we provide a minimal stub shared library. fspy's filesystem
    # tracing (LD_PRELOAD interception) will be non-functional, but all
    # other vp commands work correctly.
    echo "void __fspy_stub(void) {}" > fspy_stub.c
    $CC -shared -o libfspy_preload_unix.so fspy_stub.c
    export CARGO_CDYLIB_FILE_FSPY_PRELOAD_UNIX=$(pwd)/libfspy_preload_unix.so
  '';

  postInstall = ''
    wrapProgram $out/bin/vp \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unified toolchain and entry point for web development. It manages your runtime, package manager, and frontend toolchain in one place";
    homepage = "https://github.com/voidzero-dev/vite-plus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qweered ];
    mainProgram = "vp";
  };
})
