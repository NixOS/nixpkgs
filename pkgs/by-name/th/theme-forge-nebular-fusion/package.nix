{
  lib,
  stdenvNoCC,
  fetchurl,
  python3,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "theme-forge-nebular-fusion";
  version = "0.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/Knowledge-Forge-AI/theme-forge-nebular-fusion/releases/download/v0.4.0/theme-forge-nebular-fusion-v0.4.0-aarch64-apple-darwin.tar.gz";
    hash = "sha256-z0JZjav6G3icOJwMZ/sEIPvz6cOUfdk/hHi2DsJlKJE=";
  };

  sourceRoot = ".";

  # Do not rewrite the signed upstream app or its authenticated bundled resources.
  # The new launcher already has a Nix-store shebang, so no fixup is needed.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/Applications"
    cp -R "Theme Forge Nebular Fusion.app" "$out/Applications/"
    appBin="$out/Applications/Theme Forge Nebular Fusion.app/Contents/MacOS/theme-forge-nebular-fusion"
    test -x "$appBin"
    cat > "$out/bin/tfnf" <<EOF
    #!${stdenvNoCC.shell}
    case "\$1" in
      --version|-v) echo "theme-forge-nebular-fusion ${finalAttrs.version} (aarch64-darwin)"; exit 0 ;;
      --help|-h) echo "Theme Forge Nebular Fusion CLI launcher (aarch64-darwin Nix package)"; echo "Usage: tfnf [options]"; exit 0 ;;
      --path) echo "$out/Applications/Theme Forge Nebular Fusion.app"; exit 0 ;;
    esac
    exec "$appBin" "\$@"
    EOF
    chmod +x "$out/bin/tfnf"
    runHook postInstall
  '';

  passthru.tests.smoke =
    runCommand "${finalAttrs.pname}-smoke"
      {
        __structuredAttrs = true;
        strictDeps = true;
        nativeBuildInputs = [ python3 ];
      }
      ''
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME"
        python ${./smoke-test.py} ${finalAttrs.finalPackage} ${finalAttrs.src}
        touch "$out"
      '';

  meta = {
    description = "Desktop workbench for reviewing, inspecting, and managing Theme Forge brand systems";
    homepage = "https://github.com/Knowledge-Forge-AI/theme-forge-nebular-fusion";
    changelog = "https://github.com/Knowledge-Forge-AI/theme-forge-nebular-fusion/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.lair001 ];
    # The native application and its Node runtime are prebuilt. The bundle also
    # contains a precompiled WebAssembly renderer; neither is rebuilt by Nix.
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
    mainProgram = "tfnf";
    platforms = [ "aarch64-darwin" ];
  };
})
