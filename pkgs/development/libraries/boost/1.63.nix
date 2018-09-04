{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.63.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_63_0.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_63_0.html
    sha256 = "beae2529f759f6b3bf3f4969a19c2e9d6f0c503edcb2de4a61d1428519fcb3b0";
  };

  meta = {
    homepage = http://boost.org/;
    description = "Collection of C++ libraries";
    license = stdenv.lib.licenses.boost;

    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ peti wkennington ];
  };
})
