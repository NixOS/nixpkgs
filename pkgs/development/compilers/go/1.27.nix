{
  buildGo127Module,
  callPackage,
  fetchurl,
}:

let
  mkGoDerivation = callPackage ./generic.nix { };
in
mkGoDerivation (finalAttrs: {
  version = "1.27.3";
  src = fetchurl {
    url = "https://go.dev/dl/go${finalAttrs.version}.src.tar.gz";
    hash = "sha256-bndJA1zzYPBrJXXRYup535/ajvZxiJ5cN1+OUHd/Jrs=";
  };
  patches = [
    # This patch is never used in tree, and very rarely out-of-tree. The one exception is in
    # gomod2nix. ref. https://github.com/NixOS/nixpkgs/pull/109127 (patchfile in PR has more context)
    ./go_no_vendor_checks-1.27.patch
  ];
  buildGoModule = buildGo127Module;
})
