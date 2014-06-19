{stdenv, fetchurl, jdk, unzip}:

stdenv.mkDerivation {
  name = "GeoIPJava-1.2.5";
  src = fetchurl {
    url = http://geolite.maxmind.com/download/geoip/api/java/GeoIPJava-1.2.5.zip;
    sha256 = "1gb2d0qvvq7xankz7l7ymbr3qprwk9bifpy4hlgw0sq4i6a55ypd";
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
      mkdir -p $out/share/java
      cp maxmindgeoip.jar $out/share/java
    '';
  meta = {
    description = "GeoIP Java API";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
