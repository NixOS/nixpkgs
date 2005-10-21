{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "javasvn-0.9.3";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/org.tmatesoft.svn_0.9.3.standalone.zip;
    md5 = "8c8a1e4e3b7306ee4d933e26a5aab2ab";
  };
  
  inherit unzip;
}
