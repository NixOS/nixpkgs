{
  stdenv,
  pdfium,
  replaceVars,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "printing";
  inherit version src;
  inherit (src) passthru;

  prePatch = ''
    if [ -d printing ]; then pushd printing; fi
  '';

  patches = [
    (replaceVars ./printing.patch {
      inherit pdfium;
    })
  ];

  postPatch = ''
    popd || true
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
