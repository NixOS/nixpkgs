{ stdenvNoCC, lib, fetchurl, cosmopolitan }:

stdenvNoCC.mkDerivation {
  pname = "apeloader-bin";
  version = "1.o";

  src =
    if stdenvNoCC.isDarwin
    then
      fetchurl {
        url = "https://justine.lol/ape.macho";
        hash = "sha256-YmOv6dNDZAinKaFL8Si3Upfx+NRixXAzmDfBhzlfquA=";
      }
    else
      fetchurl {
        url = "https://justine.lol/ape.elf";
        hash = "sha256-5cVAZGX/TclfHn5UsY00x4Q99g6UP7e3K2iu6bWWNHM=";
      };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install $src -D $out/bin/ape
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://justine.lol/apeloader/";
    description = "interpreter for Cosmopolitan C programs";
    inherit (cosmopolitan.meta) license;
    mainProgram = "ape";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = teams.cosmopolitan.members;
    platforms = platforms.unix;
  };
}
