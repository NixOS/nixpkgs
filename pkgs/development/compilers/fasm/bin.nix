{
  stdenvNoCC,
  lib,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fasm-bin";
  version = "1.73.32";

  src = fetchurl {
    url = "https://flatassembler.net/fasm-${finalAttrs.version}.tgz";
    hash = "sha256-WVXL4UNWXa9e7K3MSS0CXK3lczgog9V4XUoYChvvym8=";
  };

  installPhase = ''
    runHook preInstall

    install -D fasm${lib.optionalString stdenvNoCC.hostPlatform.isx86_64 ".x64"} $out/bin/fasm

    runHook postInstall
  '';

  meta = {
    description = "x86(-64) macro assembler to binary, MZ, PE, COFF, and ELF";
    homepage = "https://flatassembler.net/download.php";
    license = lib.licenses.bsd2;
    mainProgram = "fasm";
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
