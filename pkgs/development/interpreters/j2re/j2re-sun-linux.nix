{stdenv, fetchurl}: 

assert stdenv.system == "i686-linux";


derivation {
  name = "j2re-1.4.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
      url = http://www.java.sun.com/webapps/download/AutoDL?BundleId=9500;
      md5 = "b4aae3fcda73d976bd6ae6349b36a90c";
    };
  stdenv = stdenv;
}
