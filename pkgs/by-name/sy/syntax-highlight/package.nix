{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "syntax-highlight";
  version = "2.1.32";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/sbarex/SourceCodeSyntaxHighlight/releases/download/${finalAttrs.version}/Syntax.Highlight.zip";
    hash = "sha256-IZNCkUPSUddgYr+uyDgaAM3BIOTTj9fF1XsCPFXeSW8=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R "Syntax Highlight.app" "$out/Applications/"

    ln -s \
      "$out/Applications/Syntax Highlight.app/Contents/Resources/syntax_highlight_cli" \
      "$out/bin/syntax_highlight_cli"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Quick Look extension for syntax-highlighted source file previews on macOS";
    homepage = "https://github.com/sbarex/SourceCodeSyntaxHighlight";
    changelog = "https://github.com/sbarex/SourceCodeSyntaxHighlight/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kinnrai ];
    mainProgram = "syntax_highlight_cli";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
