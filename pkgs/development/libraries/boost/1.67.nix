{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.67_0";

  patches = [ (fetchpatch {
    url = "https://github.com/boostorg/lockfree/commit/12726cda009a855073b9bedbdce57b6ce7763da2.patch";
    sha256 = "0x65nkwzv8fdacj8sw5njl3v63jj19dirrpklbwy6qpsncw7fc7h";
    stripLen = 1;
  })];

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_67_0.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_66_0.html
    sha256 = "2684c972994ee57fc5632e03bf044746f6eb45d4920c343937a465fd67a5adba";
  };
})
