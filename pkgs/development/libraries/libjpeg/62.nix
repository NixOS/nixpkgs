{stdenv, fetchurl, libtool, static ? false, ...}: 

stdenv.mkDerivation {
  name = "libjpeg-6b";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.ijg.org/files/jpegsrc.v6b.tar.gz;
    sha256 = "0pg34z6rbkk5kvdz6wirf7g4mdqn5z8x97iaw17m15lr3qjfrhvm";
  };
  
  inherit libtool;

  configureFlags = "--enable-shared ${if static then " --enable-static" else ""}";
    
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

  meta = {
        platforms = stdenv.lib.platforms.unix;
  };
}
