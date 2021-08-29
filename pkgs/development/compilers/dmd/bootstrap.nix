{ callPackage }:
callPackage ./binary.nix {
  version = "2.090.1";
  hashes = {
    # Get these from `nix-prefetch-url http://downloads.dlang.org/releases/2.x/2.090.1/dmd.2.090.1.linux.tar.xz` etc..
    osx = "0rbn7j4dr3q0y09fblpj999bi063pi4230rqd5xgd3gwxxa0cz7l";
    linux = "1vk6lsvd6y7ccvffd23yial4ig90azaxf2rxc6yvidqd1qhan807";
  };
}
