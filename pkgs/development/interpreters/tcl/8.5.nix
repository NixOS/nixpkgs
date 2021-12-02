{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  release = "8.5";
  version = "${release}.18";

  # Note: when updating, the hash in pkgs/development/libraries/tk/8.5.nix must also be updated!

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "1jfkqp2fr0xh6xvaqx134hkfa5kh7agaqbxm6lhjbpvvc1xfaaq3";
  };
})
