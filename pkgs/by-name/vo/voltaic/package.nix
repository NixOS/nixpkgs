{
  lib,
  rustPlatform,
  fetchFromGitHub,
  wasmtime,
  rustfmt,
  rustc,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "voltaic";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Industrial";
    repo = "voltaic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-be92i6aYbIyMNwr9fO1aOTBKuNRyfRyS37XP3zxBnS0=";
  };

  cargoHash = "sha256-f7WnCYdq56UIN0hcSttYA+Chfnz/2ZmUa9k/Mw93QEA=";

  # The compiler, the language server and the MCP server come from one
  # derivation: they share almost all of their dependency graph, so building
  # them separately would compile the lexer, parser and emitter three times.
  cargoBuildFlags = [
    "--package"
    "voltaic-cli"
    "--package"
    "voltaic-lsp"
    "--package"
    "voltaic-mcp"
  ];

  nativeBuildInputs = [
    # Voltaic is written in Voltaic, so the source tarball contains no Rust at
    # all - see preBuild. These two regenerate it: wasmtime runs the bootstrap
    # compiler and rustfmt formats what it emits. Both are requirements of
    # upstream's bootstrap.sh.
    wasmtime
    rustfmt

    # Not needed to build. The driver crate's build script resolves a real
    # rustc and bakes the path into the binary as VOLTAIC_RUSTC, because
    # `voltaic check` shells out to rustc at runtime - Voltaic has no type or
    # borrow checker of its own and defers to rustc for both. Baking the path
    # keeps rustc a retained runtime reference, so `voltaic check` still works
    # after a garbage collection.
    rustc
  ];

  # The source tarball contains no generated Rust: every crate's src/ is
  # produced from the .sdx sources under that crate's sdx/ and is not
  # committed. seed/voltaic1.wasm is the previous-stage compiler, checked in to
  # break the bootstrap cycle, and upstream's bootstrap.sh runs it over every
  # crate. seed/SEED.md documents the blob's provenance.
  #
  # HOME is /homeless-shelter in the sandbox and wasmtime wants a writable
  # cache directory.
  preBuild = ''
    export HOME="$NIX_BUILD_TOP/home"
    mkdir -p "$HOME"
    patchShebangs bootstrap.sh
    ./bootstrap.sh
  '';

  # The test suite is not runnable here: parts of it want an editor, node and
  # npm on PATH, a filesystem watcher plus a twenty-second budget, and a git
  # tree that fetchFromGitHub does not provide. Upstream CI runs it on every
  # push.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Source-to-source compiler for the Voltaic language, emitting ordinary Rust";
    longDescription = ''
      Voltaic compiles .sdx source to .xrs files containing ordinary Rust.
      Diagnostics are reported against the .sdx you wrote. It has no type
      checker, no borrow checker and no exhaustiveness checker of its own, by
      design: rustc is the authority on all three.

      This package provides the voltaic compiler together with the language
      server and the Model Context Protocol server.
    '';
    homepage = "https://github.com/Industrial/voltaic";
    changelog = "https://github.com/Industrial/voltaic/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "voltaic";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
