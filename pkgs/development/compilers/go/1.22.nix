{
  buildPackages,
  fetchurl,
}:

let
  bootstrap = buildPackages.callPackage ./1.20.nix { };
  version = "1.22.12";
in
buildPackages.callPackage ./generic.nix {
  inherit bootstrap version;
  src = fetchurl {
    url = "https://go.dev/dl/go${version}.src.tar.gz";
    hash = "sha256-ASp+HzfzYsCRjB36MzRFisLaFijEuc9NnKAtuYbhfXE=";
  };
}
