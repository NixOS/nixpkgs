{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "httpunit-1.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/httpunit/httpunit-1.6.zip;
    md5 = "e94b53b9f4d7bdb706e4baac95b6e424";
  };

  inherit unzip;
}
