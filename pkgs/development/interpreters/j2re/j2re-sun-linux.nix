{stdenv, fetchurl}: 

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name    = "j2re-1.4.2";
  version = "j2re1.4.2_04";
  builder = ./builder.sh;
  src = fetchurl {
      url = http://java.sun.com/webapps/download/AutoDL?BundleId=9562;
      md5 = "57e31ffc32a2956e6140ceda8aa86e4e";
    };
}
