{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "v${version}";
    sha256 = "0shk18rjhzn2lqrwk97ks3x8gj77isc8szyb3xsgjrbrvkzjgvaa";
  };
})
