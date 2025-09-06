{
  lib,
  stdenv,
  writeShellScript,
  typst,
}:

let
  typstFull = typst.withPackages (
    tpkgs:
    builtins.attrValues (
      lib.filterAttrs (
        _: maybe_p: builtins.isAttrs maybe_p && lib.hasAttrByPath [ "typstDeps" ] maybe_p
      ) tpkgs
    )
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "typst-full";
  version = "0-unstable-2025-06-24";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ${typstFull}/* $out/

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  inherit (typst) meta;
})
