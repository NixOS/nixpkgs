{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.3.1";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "v${version}";
    sha256 = "1dmvs0bhyx94ipaq3c7jmwcz4hwjmznn7310kqkqx7ly0w5vxxxr";
  };
})
