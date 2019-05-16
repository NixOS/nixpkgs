{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.0.1";

  src = fetchFromGitHub {
    owner  = "msgpack";
    repo   = "msgpack-c";
    rev    = "cpp-${version}";
    sha256 = "0nr6y9v4xbvzv717j9w9lhmags1y2s5mq103v044qlyd2jkbg2p4";
  };
})
