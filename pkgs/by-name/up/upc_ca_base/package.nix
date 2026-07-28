{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "upc_ca_base";
  version = "3.0.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://festcat.talp.cat/download/${finalAttrs.pname}-${finalAttrs.version}.tgz";
    hash = "sha256-p6ZgakktCEOBPZ6qU1IhlvZ3fa9RMSMGfV4RrLcPSrU=";
  };

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r festival/lib $out

    runHook postInstall
  '';

  meta = {
    description = "upc_ca_base is a depencency for all Festival Catalan voices developed by Festcat";
    homepage = "https://festcat.talp.cat/";
    license = with lib.licenses; [
      lgpl21Only
      free # festvox
    ];
    maintainers = with lib.maintainers; [ WiredMic ];
  };
})
