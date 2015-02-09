{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "v${version}";
    sha256 = "11j9vg55a732v14cki4721ipr942c4krr562gliqmnlwvyz0hlyb";
  };
})
