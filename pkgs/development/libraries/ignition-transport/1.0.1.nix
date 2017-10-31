{ stdenv, fetchurl, callPackage, ... } @ args :

callPackage ./generic.nix (args // rec {
  version = "1.0.1";
  src = fetchurl {
    url = "http://gazebosim.org/distributions/ign-transport/releases/ignition-transport-${version}.tar.bz2";
    sha256 = "08qyd70vlymms1g4smblags9f057zsn62xxrx29rhd4wy8prnjsq";
  };
})
