{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {
  name = "jjtraveler-0.4.3";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/jjtraveler/JJTraveler-0.4.3.tar.gz;
    md5 = "35bf801ee61f042513ae88247fe1bf1d";
  };
  buildInputs = [stdenv jdk];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
