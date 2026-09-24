{
  writeScriptBin,
  stdenv,
  lib,
  elm,
}:
let
  patchNpmElm =
    pkg:
    pkg.override (old: {
      preRebuild = (old.preRebuild or "") + ''
        rm node_modules/elm/install.js
        echo "console.log('Nixpkgs\' version of Elm will be used');" > node_modules/elm/install.js
      '';
      postInstall = (old.postInstall or "") + ''
        ln -sf ${elm}/bin/elm node_modules/elm/bin/elm
      '';
    });
in
{
  inherit patchNpmElm;
}
