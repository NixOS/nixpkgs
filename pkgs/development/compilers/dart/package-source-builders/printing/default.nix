{
  stdenv,
  pdfium-binaries,
  replaceVars,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "printing";
  inherit version src;
  inherit (src) passthru;

  patches = [
    (replaceVars ./printing.patch {
      inherit pdfium-binaries;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -a ./* $out/

    runHook postInstall
  '';
}
