{ callPackage }:
let
  inherit (callPackage ./ipkg-parse.nix { })
    importIpkg
    parseIpkg
    parseIpkgVersion
    ;
in
{
  idris2 = callPackage ./idris2.nix { };
  idris2Api = callPackage ./idris2-api.nix { };
  idris2Lsp = callPackage ./idris2-lsp.nix { };

  pack = callPackage ./pack.nix { };

  buildIdris = callPackage ./build-idris.nix { };

  inherit importIpkg parseIpkg parseIpkgVersion;
}
