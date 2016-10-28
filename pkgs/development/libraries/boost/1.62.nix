{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.62.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_62_0.tar.bz2";
    sha256 = "07h9b5n03fc9gh4pdvgp0c511fwcsxiyicajjdqm3m7jvwmdq5d7";
  };

})
