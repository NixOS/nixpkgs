{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  zsh,
  fetchNpmDeps,
  npmHooks,
  autoPatchelfHook,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "voidzero-dev";
    repo = "vite-plus";
    tag = "v${version}";
    hash = "sha256-YLlf+h0mfUMM7ealdy1CRu0p7QCYfZqRwMPsIVn1va4=";
  };

  # `vp` delegates several subcommands (e.g. `vp create`, `vp run`) to a
  # JavaScript toolchain it resolves at `<prefix>/node_modules/vite-plus/dist`.
  # Build that dependency tree from the lockfile so those commands work without
  # a project-local install. These npm dependencies ship prebuilt native
  # bindings (rolldown/oxc/oxlint/oxfmt), hence the binaryNativeCode provenance.
  nodeModules = stdenv.mkDerivation {
    pname = "vite-plus-node-modules";
    inherit version;

    src = ./npm;

    nativeBuildInputs = [
      npmHooks.npmConfigHook
      nodejs
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

    # Prefetch the npm dependency tree declared in ./npm/package-lock.json.
    # On version bumps, update package.json and remove package-lock.json, then
    # run `npm install --package-lock-only --ignore-scripts --omit=dev` in ./npm
    # and refresh the hash below.
    npmDeps = fetchNpmDeps {
      name = "vite-plus-node-modules-deps";
      src = ./npm;
      hash = "sha256-9xQWqINKispSMDMKcaVpMZPsHNtsE59UVNdHu/sAuLw=";
    };

    buildPhase = ''
      runHook preBuild
      # `vp create` copies template files out of the read-only store; without
      # this the copies keep store permissions and the scaffolded project is
      # left read-only.
      chmod -R u+w node_modules/vite-plus/dist/create
      substituteInPlace node_modules/vite-plus/dist/create/bin.js \
        --replace-fail \
          'else fs.copyFileSync(src, dest);' \
          'else { fs.copyFileSync(src, dest); fs.chmodSync(dest, 0o644); }'
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      find node_modules -name '.bin' -type d -exec rm -rf {} + 2>/dev/null || true
      rm -f node_modules/.package-lock.json
      mkdir -p $out
      mv node_modules $out/node_modules
      runHook postInstall
    '';

    # The prebuilt native bindings must not be stripped or rewritten.
    dontStrip = true;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vite-plus";
  inherit version src;

  __structuredAttrs = true;
  strictDeps = true;

  # Default `vp env` to system-first so vp uses the Nix-provided `node` on PATH
  # instead of downloading and managing its own Node.js runtime. Under Nix the
  # toolchain is provided declaratively (the devShell / flake), and a managed
  # runtime can't even execute on a pure-Nix store (no FHS dynamic loader).
  # Keep package managers managed so project version pins remain effective.
  # `vp env on` re-enables managed Node.js.
  # See https://github.com/voidzero-dev/vite-plus/issues/1899
  patches = [ ./default-to-system-first.patch ];

  postPatch = ''
    # The workspace member `packages/cli/binding` is a Node.js N-API
    # binding that depends on rolldown crates. Rolldown is not part of
    # the source tarball; it is synced externally by the justfile's
    # `sync-remote` command. Remove the member and all rolldown/string_wizard
    # path dependencies so the workspace resolves without `./rolldown/`.
    # No local (`vp_*`) crate depends on rolldown, so `vp` is unaffected.
    sed -i 's|, "packages/cli/binding"||' Cargo.toml
    sed -i -E '/^rolldown(_[a-z_]*)? = \{ path = /d; /^string_wizard = \{ path = /d' Cargo.toml
  '';

  cargoHash = "sha256-chOlu1zrC2h2IBCKaTSITBReLw4L2fw6lZxP2KDZLEg=";

  depsExtraArgs = {
    # Fixups applied to the vendor staging directory (FOD) before the
    # vendor creation step runs `cargo metadata` on each git dependency.
    postBuild = ''
        # seccompiler's git checkout bundles the `rust-vmm-ci` submodule, which
        # contains two files differing only in case (CODEOWNERS / codeowners).
        # On case-insensitive filesystems (the macOS default) they collapse into
        # one, changing the vendor hash and breaking `cargoHash` portability. The
        # submodule is CI tooling unused by the build, so drop it to keep the
        # vendor reproducible across case-sensitive and case-insensitive stores.
        rm -rf $out/git/*/rust-vmm-ci

        # The artifact macro uses nightly proc-macro dependency tracking.
        # Nix builds from scratch with immutable inputs, so incremental macro
        # tracking is unnecessary; include_bytes!(env!(...)) still embeds them.
        for f in $out/git/*/crates/materialized_artifact_macros/src/lib.rs; do
          if [ -f "$f" ]; then
            sed -i \
              -e '/^#!\[feature(proc_macro_tracked_/d' \
              -e '/^use proc_macro::tracked;/d' \
              -e '/tracked::path(&file_path);/d' \
              -e 's/tracked::env_var(/std::env::var(/g' \
              "$f"
          fi
        done

        # The vite-task workspace uses `artifact = "cdylib"` / `artifact = "bin"`
        # dependency annotations (with an optional `target = "..."`) which require
        # the unstable `-Z bindeps` cargo flag. Stable cargo's `cargo metadata`
        # rejects them, so strip the annotations from every vendored manifest.
        # This is safe for vendoring: artifact deps are only used at runtime
        # (LD_PRELOAD libs) or in tests, neither of which the vendor step needs.
        for f in $out/git/*/Cargo.toml $out/git/*/crates/*/Cargo.toml; do
          if [ -f "$f" ]; then
            sed -i \
              -e 's/, *artifact = "[^"]*"//g' \
              -e 's/, *target = "[^"]*"//g' \
              "$f"
          fi
        done

        # fspy's preload libraries (fspy_preload_unix, fspy_preload_windows)
        # require cargo's unstable artifact dependencies. fspy embeds them via
        # include_bytes!(env!("CARGO_CDYLIB_FILE_...")). Drop them from fspy's
        # dependency list; a stub cdylib is provided instead (see preBuild).
        # Also drop fspy_test_bin (dev-dep, `artifact = "bin"`).
        for f in $out/git/*/crates/fspy/Cargo.toml; do
          if [ -f "$f" ]; then
            sed -i \
              -e '/fspy_preload_unix/d' \
              -e '/fspy_preload_windows/d' \
              -e '/fspy_test_bin/d' \
              "$f"
          fi
        done

        # On macOS, fspy's build script downloads helper binaries (oils-for-unix,
        # coreutils) from GitHub at build time, which is impossible in the
        # network-free build sandbox. Register a stub artifact and skip the
        # download. This degrades fspy's macOS shell helpers (consistent with the
        # stubbed preload cdylib); all other `vp` commands work. On Linux the
        # function returns early upstream, so this block is a no-op there.
        for f in $out/git/*/crates/fspy/build.rs; do
          if [ -f "$f" ]; then
            substituteInPlace "$f" \
              --replace-fail \
              'fn fetch_macos_binaries(out_dir: &Path) -> anyhow::Result<()> {' \
              'fn fetch_macos_binaries(out_dir: &Path) -> anyhow::Result<()> {
      if env::var("CARGO_CFG_TARGET_OS").unwrap() == "macos" {
          let stub = out_dir.join("nixpkgs-fspy-macos-stub");
          fs::write(&stub, b"#!/bin/sh\nexit 127\n")?;
          println!("cargo:rustc-env=FSPY_MACOS_ARTIFACT_OILS_FOR_UNIX={}", stub.display());
          println!("cargo:rustc-env=FSPY_MACOS_ARTIFACT_COREUTILS={}", stub.display());
          return Ok(());
      }'
          fi
        done
    '';
  };

  cargoBuildFlags = [
    "-p"
    "vp_global_cli"
  ];
  cargoTestFlags = [
    "-p"
    "vp_global_cli"
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    nodejs
    zsh
  ];

  # Avoid file-lock races with tests that spawn subprocesses.
  dontUseCargoParallelTests = true;

  checkFlags = [
    # Resolve / download / execute a managed Node.js runtime (network + arch)
    "--skip=test_delegate_to_local_cli_prints_node_version"
    "--skip=ensure_project_runtime_allows_older_unsupported_node"
    # Network: resolve version from nodejs.org/dist/index.json
    "--skip=commands::env::config::tests::"
    "--skip=commands::env::exec::tests::"
    "--skip=commands::env::pin::tests::"
    # Rendering test sensitive to environment
    "--skip=help::tests::render_help_doc_appends_documentation_footer"
  ];

  preBuild = ''
    # fspy embeds the fspy_preload_unix cdylib at compile time via
    #   include_bytes!(env!("CARGO_CDYLIB_FILE_FSPY_PRELOAD_UNIX"))
    # That env var is normally set by cargo's unstable `-Z bindeps` flag.
    # Provide a minimal stub shared library instead. fspy's filesystem tracing
    # (LD_PRELOAD interception) is non-functional.
    echo "void __fspy_stub(void) {}" > fspy_stub.c
    $CC -shared -fPIC -o libfspy_preload_unix.so fspy_stub.c
    export CARGO_CDYLIB_FILE_FSPY_PRELOAD_UNIX=$(pwd)/libfspy_preload_unix.so
  '';

  postInstall = ''
    # Nix installs the complete toolchain. Skip the first-launch installer,
    # which otherwise creates a second installation in the user's home.
    touch $out/bin/.vp-setup-complete

    # Provide the JS toolchain alongside the binary so `vp`'s delegated
    # subcommands (`vp create`, `vp run`, ...) resolve it at
    # `$out/node_modules/vite-plus/dist`.
    ln -s ${nodeModules}/node_modules $out/node_modules

    wrapProgram $out/bin/vp \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]}

    ln -s vp $out/bin/vpr
    ln -s vp $out/bin/vpx
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unified toolchain and entry point for web development";
    homepage = "https://github.com/voidzero-dev/vite-plus";
    changelog = "https://github.com/voidzero-dev/vite-plus/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ fengmk2 ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "vp";
  };
})
