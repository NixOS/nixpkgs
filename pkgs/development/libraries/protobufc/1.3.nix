{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.3.3";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "v${version}";
    sha256 = "13948amsjj9xpa4yl6amlyk3ksr96bbd4ngshh2yzflwcslhg6gv";
  };
})
