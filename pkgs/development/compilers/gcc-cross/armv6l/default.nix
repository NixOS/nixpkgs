{ pkgs }:
let
  ctng = import ../ctng-build.nix { inherit pkgs; };
in
ctng.mkCrossToolchain {
  name = "armv6l-unknown-linux-gnueabihf";
  config = pkgs.fetchurl {
    url = http://us.mirror.archlinuxarm.org/mirror/development/ct-ng/xtools-dotconfig-v6;
    sha256 = "0flh16kd9wzpkak0zznj7n6jqnradhi1sik1iw2i3n8i1i684py3";
  };
  toolchainPrefix = "armv6l-linux-gnueabihf";
}
