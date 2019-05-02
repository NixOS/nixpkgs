{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.3.1";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    #rev = "v${version}";
    rev = "9412830d0680150d429d2aa170b8d7218ab49397";
    sha256 = "175cmaj5231iqzhf5a9sxw2y3i165chk3681m1b5mp8di927q5ai";
  };
})
