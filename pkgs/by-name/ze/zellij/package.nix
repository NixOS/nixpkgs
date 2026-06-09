{
  lib,
  zellij-unwrapped,
  makeBinaryWrapper,
  stdenvNoCC,

  extraPackages ? [ ],
}:
stdenvNoCC.mkDerivation {
  inherit (zellij-unwrapped) version meta;
  pname = "zellij";

  __structuredAttrs = true;
  strictDeps = true;

  src = zellij-unwrapped;
  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildPhase = ''
    cp -rs --no-preserve=mode "$src" "$out"

    wrapProgram "$out/bin/zellij" \
      --prefix PATH : '${lib.makeBinPath extraPackages}'
  '';
}
