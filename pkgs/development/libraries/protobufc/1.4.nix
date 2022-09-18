{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "refs/tags/v${version}";
    hash = "sha256-TJCLzxozuZ8ynrBQ2lKyk03N+QA/lbOwywUjDUdTlbM=";
  };
})
