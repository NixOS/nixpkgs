{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "v${version}";
    sha256 = "1harabw7qdgcmh098664xkcv8bkyach6i35sisc40yhvagr3fzsz";
  };
})
