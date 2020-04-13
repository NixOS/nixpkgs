{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.2.0";

  src = fetchFromGitHub {
    owner  = "msgpack";
    repo   = "msgpack-c";
    rev    = "cpp-${version}";
    sha256 = "07n0kdmdjn3amwfg7fqz3xac1yrrxh7d2l6p4pgc6as087pbm8pl";
  };
})
