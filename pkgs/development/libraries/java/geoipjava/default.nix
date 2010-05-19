{stdenv, fetchurl, jdk, unzip}:

stdenv.mkDerivation {
  name = "GeoIPJava-1.2.3";
  src = fetchurl {
    url = http://geolite.maxmind.com/download/geoip/api/java/GeoIPJava-1.2.3.zip;
    sha256 = "0l8vxan2xh0mp1vjxh39q05jyfw8gk5y77b7i8s1aw7ssyzd05vs";
  };
  buildInputs = [ jdk unzip ];
  buildPhase = 
    ''
      cd source
      javac $(find . -name \*.java)
      jar cfv maxmindgeoip.jar $(find . -name \*.class)
    '';
  installPhase =
    ''
      ensureDir $out/share/java
      cp maxmindgeoip.jar $out/share/java
    '';
  meta = {
    description = "GeoIP Java API";
    license = "LGPL2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
