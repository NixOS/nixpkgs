{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.5.0";
  # make sure you test also -A pythonPackages.protobuf
  src = fetchurl {
    url = "http://protobuf.googlecode.com/files/${version}.tar.bz2";
    sha256 = "0xxn9gxhvsgzz2sgmihzf6pf75clr05mqj6218camwrwajpcbgqk";
  };
})