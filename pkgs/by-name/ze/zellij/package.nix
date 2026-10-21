{
  lib,
  zellij-unwrapped,
  makeBinaryWrapper,
  stdenvNoCC,
  symlinkJoin,

  extraPackages ? [ ],
}:
if extraPackages == [ ] then
  symlinkJoin {
    inherit (zellij-unwrapped) version meta;
    pname = "zellij";

    __structuredAttrs = true;
    strictDeps = true;

    paths = [ zellij-unwrapped ];
  }
else
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
