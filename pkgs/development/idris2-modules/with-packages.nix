{ lib, makeWrapper, symlinkJoin, callPackage, idris2, ... }: packages:

let
  name = idris2.name;
  paths = lib.closePropagation packages;
in symlinkJoin {
  inherit (idris2) name;

  paths = paths ++ [ idris2 ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/idris2 \
      --prefix IDRIS2_PACKAGE_PATH ':' "$out/${name}"
  '';
}

