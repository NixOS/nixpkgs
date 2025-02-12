{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  tailwindcss_4,
}:
let
  version = "4.0.6";
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "tailwindcss has not been packaged for ${system} yet.";

  plat =
    {
      aarch64-darwin = "macos-arm64";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "macos-x64";
      x86_64-linux = "linux-x64";
    }
    .${system} or throwSystem;

  hash =
    {
      aarch64-darwin = "sha256-FopnfuGYBjjQkfPHdIWacpom9WsAVRwHPQ/14waWR7s=";
      aarch64-linux = "sha256-y+9d53skmoSZPhbtk9vUkhKNzIE1A868Lnkw7Cot/PU=";
      x86_64-darwin = "sha256-rFjaDtPjJO9W6G//7Uu5CJE+pB0sqLrMByC5pv4FA4E=";
      x86_64-linux = "sha256-14EMXenpvPsKlnu5kebNu3MmfWwa7UYfAgEkh5EwVRM=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation {
  inherit version;
  pname = "tailwindcss_4";

  src = fetchurl {
    url =
      "https://github.com/tailwindlabs/tailwindcss/releases/download/v${version}/tailwindcss-" + plat;
    inherit hash;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    install -D $src $out/bin/tailwindcss
  '';

  passthru.tests.helptext = runCommand "tailwindcss-test-helptext" { } ''
    ${tailwindcss_4}/bin/tailwindcss --help > $out
  '';
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Command-line tool for the CSS framework with composable CSS classes, standalone v4 CLI";
    homepage = "https://tailwindcss.com/blog/tailwindcss-v4";
    license = licenses.mit;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = [ maintainers.adamjhf ];
    mainProgram = "tailwindcss";
    platforms = platforms.darwin ++ platforms.linux;
  };
}
