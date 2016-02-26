{ pkgs }:
let
  ctng = import ../ctng-build.nix { inherit pkgs; };
in
ctng.mkCrossToolchain {
  name = "armv5te-unknown-linux-gnueabi";
  config = pkgs.fetchurl {
    url = http://us.mirror.archlinuxarm.org/mirror/development/ct-ng/xtools-dotconfig-v5;
    sha256 = "05vcgfih5xiy4wv87rg1hhpcw3shqda9kgnia275a9n7h90qkn43";
  };
  toolchainPrefix = "armv5te-linux-gnueabi";
}
