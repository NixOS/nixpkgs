{
  stdenvNoCC,
  lib,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fasm-bin";
  version = "1.73.34";

  src = fetchurl {
    url = "https://flatassembler.net/fasm-${finalAttrs.version}.tgz";
    hash = "sha256-CAlGTsfvpDRWsHh9UysgBorjX+mygEWjFeRaznyDszw=";
  };

  installPhase = ''
    runHook preInstall

    install -D fasm${lib.optionalString stdenvNoCC.hostPlatform.isx86_64 ".x64"} $out/bin/fasm

    runHook postInstall
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
