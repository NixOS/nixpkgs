{
  lib,
  stdenv,
  buildVscode,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:
let
  info =
    (lib.importJSON ./info.json)."${stdenv.hostPlatform.system}"
      or (throw "windsurf-next: unsupported system ${stdenv.hostPlatform.system}");
in
buildVscode {
  inherit commandLineArgs useVSCodeRipgrep;

  inherit (info) version vscodeVersion;
  pname = "windsurf-next";

  executableName = "windsurf-next";
  longName = "Windsurf Next";
  shortName = "windsurf-next";
  libraryName = "windsurf-next";
  iconName = "windsurf-next";

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Windsurf - Next.app" else "Windsurf";
  sourceExecutableName = if stdenv.hostPlatform.isDarwin then "Windsurf - Next" else "windsurf-next";

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
    homepage = "https://windsurf.com";
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
