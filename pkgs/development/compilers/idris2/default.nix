{ callPackage }:
{
  idris2 = callPackage ./idris2.nix { };
  idris2Api = callPackage ./idris2-api.nix { };
  idris2Lsp = callPackage ./idris2-lsp.nix { };

  buildIdris = callPackage ./build-idris.nix { };
}
