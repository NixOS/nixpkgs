{ lib, stdenv, cosmopolitan, nixosTests }:

stdenv.mkDerivation {
  pname = "apeloader";
  version = "1.o";

  src = cosmopolitan.dist;

  # slashes are significant because upstream uses o/$(MODE)/foo.o
  buildFlags = "o//ape/ape.elf";
  enableParallelBuilding = true;

  doInstallCheck = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install o/ape/ape.elf -D $out/bin/ape
    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/ape build/bootstrap/echo.com Hello world!
  '';

  passthru.tests = {
    inherit (nixosTests) apeloader;
  };

  meta = with lib; {
    homepage = "https://justine.lol/apeloader/";
    description = "interpreter for Cosmopolitan C programs";
    inherit (cosmopolitan.meta) license;
    mainProgram = "ape";
    maintainers = teams.cosmopolitan.members;
  };
}
