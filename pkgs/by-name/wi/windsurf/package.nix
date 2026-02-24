{
  lib,
  stdenv,
  callPackage,
  vscode-generic,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:
let
  info =
    (lib.importJSON ./info.json)."${stdenv.hostPlatform.system}"
      or (throw "windsurf: unsupported system ${stdenv.hostPlatform.system}");
in
callPackage vscode-generic {
  inherit commandLineArgs useVSCodeRipgrep;

  inherit (info) version vscodeVersion;
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";
  libraryName = "windsurf";
  iconName = "windsurf";

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Windsurf.app" else "Windsurf";

  src = fetchurl { inherit (info) url sha256; };

  tests = nixosTests.vscodium;

  updateScript = ./update/update.mts;

  # Editing the `codium` binary (and shell scripts) within the app bundle causes the bundle's signature
  # to be invalidated, which prevents launching starting with macOS Ventura, because VSCodium is notarized.
  # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
  dontFixup = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Agentic IDE powered by AI Flow paradigm";
    longDescription = ''
      The first agentic IDE, and then some.
      The Windsurf Editor is where the work of developers and AI truly flow together, allowing for a coding experience that feels like literal magic.
    '';
    homepage = "https://codeium.com/windsurf";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      sarahec
      xiaoxiangmoe
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
