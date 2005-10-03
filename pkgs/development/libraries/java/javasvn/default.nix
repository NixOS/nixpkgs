{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "javasvn-0.9.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://tmate.org/svn/org.tmatesoft.svn_0.9.2.standalone.zip;
    md5 = "0f51c8a5daadccd0a7c301b265fda893";
  };
  
  inherit unzip;
}
