{ pkgs }:
let
  ctng = import ../ctng-build.nix { inherit pkgs; };
in
ctng.mkCrossToolchain {
  name = "armv7l-unknown-linux-gnueabihf";
  config = pkgs.fetchurl {
    url = http://us.mirror.archlinuxarm.org/mirror/development/ct-ng/xtools-dotconfig-v7;
    sha256 = "1nsgw1pf0jswwsw6lzf92l6ak6vjzf4jg8fgb5riy5wq30zr033b";
  };
  toolchainPrefix = "armv7l-linux-gnueabihf";
}
