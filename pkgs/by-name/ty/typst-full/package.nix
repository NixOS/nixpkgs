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
typstFull.overrideAttrs (
  finalAttrs: _: {
    name = "typst-full-${finalAttrs.version}";
    version = "0-unstable-2025-09-22";
    passthru.updateScript = ./update.sh;
  }
)
