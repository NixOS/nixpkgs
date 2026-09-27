{
  lib,
  stdenvNoCC,
  makeWrapper,
  versionCheckHook,
  plover,
}:
pythonEnv:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pythonEnv;
  pname = "plover-wrapper-with-plugins";
  inherit (plover) version;
  nativeBuildInputs = [
    makeWrapper
  ];
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "''${!outputBin}/bin"
    for _pathFromPlover in ${lib.getBin plover}/bin/*; do
      _nameFromPlover=$(basename "$_pathFromPlover")
      makeWrapper "$pythonEnv/bin/$_nameFromPlover" "''${!outputBin}/bin/$_nameFromPlover"
    done
    runHook postInstall
  '';
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  meta = removeAttrs plover.meta [
    "attrs"
    "position"
    "references"
    "validity"
  ];
})
