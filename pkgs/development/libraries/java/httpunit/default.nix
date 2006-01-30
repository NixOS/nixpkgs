{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "httpunit-1.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/httpunit-1.6.zip;
    md5 = "e94b53b9f4d7bdb706e4baac95b6e424";
  };

  inherit unzip;
}
