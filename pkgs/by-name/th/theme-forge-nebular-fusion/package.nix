{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "theme-forge-nebular-fusion";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/Knowledge-Forge-AI/theme-forge-nebular-fusion/releases/download/v0.4.0/theme-forge-nebular-fusion-v0.4.0-aarch64-apple-darwin.tar.gz";
    hash = "sha256-z0JZjav6G3icOJwMZ/sEIPvz6cOUfdk/hHi2DsJlKJE=";
  };

  sourceRoot = ".";

  installPhase = ''
        runHook preInstall
        mkdir -p "$out/bin" "$out/Applications"
        cp -R "Theme Forge Nebular Fusion.app" "$out/Applications/"
        appBin="$out/Applications/Theme Forge Nebular Fusion.app/Contents/MacOS/theme-forge-nebular-fusion"
        test -x "$appBin"
        cat > "$out/bin/tfnf" <<EOF
    #!/bin/sh
    case "\$1" in
      --version|-v) echo "theme-forge-nebular-fusion 0.4.0 (aarch64-darwin)"; exit 0 ;;
      --help|-h) echo "Theme Forge Nebular Fusion CLI launcher (aarch64-darwin Nix package)"; echo "Usage: tfnf [options]"; exit 0 ;;
      --path) echo "$out/Applications/Theme Forge Nebular Fusion.app"; exit 0 ;;
    esac
    exec "$appBin" "\$@"
    EOF
        chmod +x "$out/bin/tfnf"
        runHook postInstall
  '';

  meta = {
    description = "Desktop workbench for reviewing, inspecting, and managing Theme Forge brand systems";
    homepage = "https://github.com/Knowledge-Forge-AI/theme-forge-nebular-fusion";
    license = lib.licenses.agpl3Plus;
    mainProgram = "tfnf";
    platforms = [ "aarch64-darwin" ];
  };
})
