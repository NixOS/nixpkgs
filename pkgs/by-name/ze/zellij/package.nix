{
  lib,
  callPackage,
  makeBinaryWrapper,
  stdenvNoCC,
  nix-update-script,

  extraPackages ? [ ],
}:
let
  unwrapped = callPackage ./unwrapped.nix { };
in
stdenvNoCC.mkDerivation {
  inherit (unwrapped) version meta;
  pname = "zellij";

  __structuredAttrs = true;
  strictDeps = true;

  src = unwrapped;
  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildPhase = ''
    cp -rs --no-preserve=mode "$src" "$out"

    wrapProgram "$out/bin/zellij" \
      --prefix PATH : '${lib.makeBinPath extraPackages}'
  '';

  passthru = unwrapped.passthru or { } // {
    inherit unwrapped;
    updateScript = nix-update-script { attrPath = "zellij.unwrapped"; };
  };
}
