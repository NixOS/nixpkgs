{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.0.0-alpha-3.1";
  # make sure you test also -A pythonPackages.protobuf
  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "0vzw20ymjmjrrmg84f822qslclsb2q0wf0qdj2da198gmkkbrw45";
  };
})
