{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.6.1";
  # make sure you test also -A pythonPackages.protobuf
  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "03df8zvx2sry3jz2x4pi3l32qyfqa7w8kj8jdbz30nzy0h7aa070";
  };
})
