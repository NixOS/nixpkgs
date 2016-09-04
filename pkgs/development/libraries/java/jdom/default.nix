{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "jdom-1.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.jdom.org/dist/binary/jdom-1.0.tar.gz;
    md5 = "ce29ecc05d63fdb419737fd00c04c281";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
