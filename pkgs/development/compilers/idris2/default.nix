{ callPackage
, idris2Packages
}:

let
in {
  idris2 = callPackage ./idris2.nix { };
  idris2Lsp = callPackage ./idris2-lsp.nix { };

  buildIdris = callPackage ./build-idris.nix { };

  idris2Api = (idris2Packages.buildIdris {
    inherit (idris2Packages.idris2) src version;
    ipkgName = "idris2api";
    idrisLibraries = [ ];
    preBuild = ''
      export IDRIS2_PREFIX=$out/lib
      make src/IdrisPaths.idr
    '';
  }).library;
}
