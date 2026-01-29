{
  gccgo,
  fetchurl,
  buildPackages,
}:

let
  version = "1.17.13";
in
buildPackages.callPackage ./generic.nix {
  version = "1.17.13";
  bootstrap = gccgo;
  src = fetchurl {
    url = "https://go.dev/dl/go${version}.src.tar.gz";
    hash = "sha256-oaSLI6+yBvlee7qpuJjZZfkIJvbx0fwMHXhK2gzTAP0=";
  };
}
