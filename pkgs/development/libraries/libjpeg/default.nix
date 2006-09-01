{stdenv, fetchurl, libtool}: 

stdenv.mkDerivation {
  name = "libjpeg-6b";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/jpegsrc.v6b.tar.gz;
    md5 = "dbd5f3b47ed13132f04c685d608a7547";
  };
  inherit libtool;

  # Required for building of dynamic libraries on Darwin.
  patches = [
    (fetchurl {
      url = http://svn.macports.org/repository/macports/trunk/dports/graphics/jpeg/files/patch-ltconfig;
      md5 = "e6725fa4a09aa1de4ca75343fd0f61d5";
    })
    (fetchurl {
      url = http://svn.macports.org/repository/macports/trunk/dports/graphics/jpeg/files/patch-ltmain.sh;
      #md5 = "489986ad8e7a93aef036766b25f321d5";
      md5 = "092a12aeb0c386dd7dae059109d950ba";
    })
  ];
}
