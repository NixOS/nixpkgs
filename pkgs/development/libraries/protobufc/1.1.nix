{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.1.1";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "v${version}";
    sha256 = "0mdl2i87394l4zdvq2npsxq4zs8p7sqhqmbm2r380ngjs6zic6gw";
  };
})
