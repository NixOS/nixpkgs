{
  buildPackages,
  fetchurl,
}:

let
  bootstrap = buildPackages.callPackage ./1.17.nix { };
  version = "1.20.14";
in
buildPackages.callPackage ./generic.nix {
  inherit bootstrap version;
  src = fetchurl {
    url = "https://go.dev/dl/go${version}.src.tar.gz";
    hash = "sha256-Gu8yGg4+OLfpHS1+tkBAZmyr3Md9OD3jyVItDWm2f04=";
  };
}
