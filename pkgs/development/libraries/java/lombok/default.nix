{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "lombok-1.16.8";
  src = fetchurl {
    url = "https://projectlombok.org/downloads/${name}.jar";
    sha256 = "0s7ak6gx1h04da2rdhvc0fk896cwqm2m7g3chqcjpsrkgfdv4cpy";
  };
  phases = [ "installPhase" ];
  installPhase = "mkdir -p $out/share/java; cp $src $out/share/java/lombok.jar";
  meta = {
    description = "A library that can write a lot of boilerplate for your Java project";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mit;
    homepage = https://projectlombok.org/;
    maintainers = [ stdenv.lib.maintainers.CrystalGamma ];
  };
}
