{
  lib,
  stdenv,
  writeShellScript,
  typst,
}:

let
  packageSetVersion = lib.substring 0 7 (
    builtins.hashFile "sha256" ../typst/typst-packages-from-universe.toml
  );
  typstFull = typst.withPackages (tpkgs:
    builtins.attrValues (
      lib.filterAttrs
        (_: maybe_p: builtins.isAttrs maybe_p && lib.hasAttrByPath ["typstDeps"] maybe_p)
        tpkgs
    )
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "typst-full";
  version = "${typst.version}.${packageSetVersion}";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ${typstFull}/* $out/

    runHook postInstall
  '';

  passthru.updateScript = {
    command = [ ./update.sh ];
    supportedFeatures = [ "commit" ];
  };

  inherit (typst) meta;
})
