{
  stdenvNoCC,
  lib,
  fetchurl,
  writeShellScript,
  curl,
  nix-update,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fasm-bin";
  version = "1.73.35";

  src = fetchurl {
    url = "https://flatassembler.net/fasm-${finalAttrs.version}.tgz";
    hash = "sha256-o03sfQvC3Hn6q7aL2LwvYrbPsx1pwBRJNnzkzYCYk04=";
  };

  installPhase = ''
    runHook preInstall

    install -D fasm${lib.optionalString stdenvNoCC.hostPlatform.isx86_64 ".x64"} $out/bin/fasm

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-fasm" ''
    set -euo pipefail

    version=""
    while IFS= read -r line; do
      if [[ "$line" =~ fasm-([0-9]+\.[0-9]+\.[0-9]+)\.tgz ]]; then
        version="''${BASH_REMATCH[1]}"
        break
      fi
    done < <(${lib.getExe curl} -fsSL https://flatassembler.net/download.php)

    if [[ -z "$version" ]]; then
      echo "Could not determine latest fasm version" >&2
      exit 1
    fi

    ${lib.getExe nix-update} fasm-bin --version "$version"
  '';

  meta = {
    description = "x86(-64) macro assembler to binary, MZ, PE, COFF, and ELF";
    homepage = "https://flatassembler.net/";
    downloadPage = "https://flatassembler.net/download.php";
    license = lib.licenses.bsd2;
    mainProgram = "fasm";
    maintainers = [ lib.maintainers.iamanaws ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
