{
  stdenv,
  lib,
  writeScript,
  olm,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "olm";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "${pname}-setup-hook" ''
    olmFixupHook() {
      runtimeDependencies+=('${lib.getLib olm}')
    }

    preFixupHooks+=(olmFixupHook)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ln -s '${src}'/* "$out"

    runHook postInstall
  '';
}
