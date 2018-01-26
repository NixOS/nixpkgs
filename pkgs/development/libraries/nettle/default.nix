{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "150y8655h629wn946dvzasq16qxsc1m9nf58mifvhl350bgl4ymf";
  };
})
