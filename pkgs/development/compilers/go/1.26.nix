{
  buildGo126Module,
  callPackage,
  fetchurl,
}:

let
  version = "1.26.11";
in
callPackage ./generic.nix {
  inherit version;
  src = fetchurl {
    url = "https://go.dev/dl/go${version}.src.tar.gz";
    hash = "sha256-1EEBsP8n7SpMda1GwXucdDWSCeLrLKfJ32y0/baOGWk=";
  };
  extraPatches = [
    # This patch is never used in tree, and very rarely out-of-tree. The one exception is in
    # gomod2nix. ref. https://github.com/NixOS/nixpkgs/pull/109127 (patchfile in PR has more context)
    ./go_no_vendor_checks-1.26.patch
  ];
  buildGoModule = buildGo126Module;
}
