{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.62.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_62_0.tar.bz2";
    # long-form SHA256 from www.boost.org
    sha256 = "36c96b0f6155c98404091d8ceb48319a28279ca0333fba1ad8611eb90afb2ca0";
  };

})
