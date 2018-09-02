{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.62.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_62_0.tar.bz2";
    # long-form SHA256 from www.boost.org
    sha256 = "36c96b0f6155c98404091d8ceb48319a28279ca0333fba1ad8611eb90afb2ca0";
  };

  meta = {
    homepage = http://boost.org/;
    description = "Collection of C++ libraries";
    license = stdenv.lib.licenses.boost;

    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ peti wkennington ];
  };
})
