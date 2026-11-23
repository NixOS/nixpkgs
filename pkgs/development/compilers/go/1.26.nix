{
  buildGo126Module,
  callPackage,
  fetchurl,
}:

let
  mkGoDerivation = callPackage ./generic.nix { };
in
mkGoDerivation (finalAttrs: {
  version = "1.26.11";
  src = fetchurl {
    url = "https://go.dev/dl/go${finalAttrs.version}.src.tar.gz";
    hash = "sha256-1EEBsP8n7SpMda1GwXucdDWSCeLrLKfJ32y0/baOGWk=";
  };
  patches = [
    # This patch is never used in tree, and very rarely out-of-tree. The one exception is in
    # gomod2nix. ref. https://github.com/NixOS/nixpkgs/pull/109127 (patchfile in PR has more context)
    ./go_no_vendor_checks-1.26.patch
  ];
  buildGoModule = buildGo126Module;
  internalPIESupport = {
    android = [ "arm64" ];
    darwin = [
      "amd64"
      "arm64"
    ];
    linux = [
      "amd64"
      "arm64"
      "loong64"
      "ppc64le"
    ];
    windows = [
      "386"
      "amd64"
      "arm64"
    ];
  };
})
