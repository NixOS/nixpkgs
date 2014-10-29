{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (rec {
  version = "1.56.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_56_0.tar.bz2";
    sha256 = "07gz62nj767qzwqm3xjh11znpyph8gcii0cqhnx7wvismyn34iqk";
  };
})
