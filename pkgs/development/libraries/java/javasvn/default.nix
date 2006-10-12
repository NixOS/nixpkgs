{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "javasvn-1.0.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/org.tmatesoft.svn_1.0.6.standalone.zip;
    md5 = "459cae849eceef04cd65fd6fb54affcc";
  };
  
  inherit unzip;
}
