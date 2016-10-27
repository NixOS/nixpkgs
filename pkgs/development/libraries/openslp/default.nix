{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation {
  name = "openslp-2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/openslp/2.0.0/2.0.0/openslp-2.0.0.tar.gz";
    sha256 = "16splwmqp0400w56297fkipaq9vlbhv7hapap8z09gp5m2i3fhwj";
  };

  patches = [
    (fetchpatch {
      name = "openslp-2.0.0-null-pointer-deref.patch";
      url = "https://svnweb.mageia.org/packages/cauldron/openslp/current/SOURCES/openslp-2.0.0-null-pointer-deref.patch?revision=1019712&view=co";
      sha256 = "186f3rj3z2lf5h1lpbhqk0szj2a9far1p3mjqg6422f29yjfnz6a";
    })
    (fetchpatch {
      name = "openslp-2.0.0-CVE-2016-7567.patch";
      url = "https://svnweb.mageia.org/packages/cauldron/openslp/current/SOURCES/openslp-2.0.0-CVE-2016-7567.patch?revision=1057233&view=co";
      sha256 = "1zrgql91vjjl2v7brlibc8jqndnjz9fclqbdn0b6fklkpwznprny";
    })
  ];

  meta = with stdenv.lib; {
    homepage = "http://openslp.org/";
    description = "An open-source implementation of the IETF Service Location Protocol";
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };

}
