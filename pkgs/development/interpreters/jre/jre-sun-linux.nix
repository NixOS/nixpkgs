{stdenv, fetchurl}: 

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name    = "jre-1.5.0";
  version = "jre1.5.0_06";
  builder = ./builder.sh;
  src = fetchurl {
      url = "http://jdl.sun.com/webapps/download/AutoDL?BundleId=10336";
      md5 = "e0a88dbec9bfe3195794bb652bfc6516";
    };
}
