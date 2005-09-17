{stdenv, fetchurl}: 

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name    = "jre-1.5.0";
  version = "jre1.5.0_02";
  builder = ./builder.sh;
  src = fetchurl {
      url = http://jdl.sun.com/webapps/download/AutoDL?BundleId=9986;
      md5 = "1c9b3bb9670df5ebb5587d2bcba73b3c";
    };
}
