{
  lib,
  rustPlatform,
  fetchFromGitHub,
  doxx,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xleak";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "xleak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n9AFNGr5kRbQr2P/6QFT0KkuiE6KPun1FZjwrq2iQZs=";
  };

  cargoHash = "sha256-wWN8FSaIndp9piqRHMMYyWp7iynhWQeUfzT8FDYQUyA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal Excel viewer with an interactive TUI";
    longDescription = ''
      Inspired by [`doxx`](${doxx.meta.homepage}), `xleak` brings
      Excel spreadsheets to your command line with beautiful
      rendering, powerful export capabilities, and a feature-rich
      interactive TUI.  Featuring full-text search, formula display,
      lazy loading for large files, clipboard support, and export to
      CSV/JSON.
    '';
    homepage = "https://github.com/bgreenwell/xleak";
    changelog = "https://github.com/bgreenwell/xleak/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "xleak";
  };
})
