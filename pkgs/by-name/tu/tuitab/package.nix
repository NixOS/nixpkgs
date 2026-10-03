{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuitab";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "denisotree";
    repo = "tuitab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0cotCc3dOFSJXZcRHzkHm2UML1ub1jA39GiDtlxPUpI=";
  };

  cargoHash = "sha256-/U1mxPWwjboOZJSecV56F9wo4F8P2JXO/mAjx6SQ+J4=";

  __structuredAttrs = true;

  # ttab and ttb are separate [[bin]] targets whose source is byte-identical to
  # `fn main() { tuitab::run() }`, so building them yields three full copies of a
  # ~110 MB binary. Build one and symlink the aliases; argv[0] is never read.
  # Do not restrict cargoTestFlags the same way: tests/mcp_tests.rs needs
  # CARGO_BIN_EXE_tuitab.
  cargoBuildFlags = [
    "--bin"
    "tuitab"
  ];

  # checkPhase runs before installPhase and may leave ttab/ttb in target/release
  # for installPhase to pick up, hence `ln -sf` rather than `ln -s`.
  postInstall = ''
    ln -sf tuitab $out/bin/ttab
    ln -sf tuitab $out/bin/ttb
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, keyboard-driven terminal explorer for tabular data";
    longDescription = ''
      tuitab opens CSV, TSV, JSON, JSONL, YAML, TOML, Parquet, Arrow, Excel,
      SQLite and DuckDB files as a table and lets you filter, sort, pivot, join,
      add computed columns and draw charts without leaving the terminal.
    '';
    homepage = "https://github.com/denisotree/tuitab";
    changelog = "https://github.com/denisotree/tuitab/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "tuitab";
    maintainers = with lib.maintainers; [ denisotree ];
    platforms = lib.platforms.unix;
  };
})
