{ stdenv, lib, makeWrapper, caja-extensions, caja, extensions ? [ caja-extensions ] }:

stdenv.mkDerivation {
  pname = "${caja.pname}-with-extensions";
  version = caja.version;

  phases = [ "installPhase" ];

  nativeBuildInputs = [ makeWrapper ];

  inherit caja;

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper $caja/bin/caja $out/bin/caja \
    --set CAJA_EXTENSION_DIRS ${lib.concatMapStringsSep ":" (x: "${x.outPath}/lib/caja/extensions-2.0") extensions}
  '';

  inherit (caja.meta);
}
