{stdenv, fetchurl, aterm, sdf, strategoxt, pkgconfig}:

stdenv.mkDerivation {
  name = "java-front-0.9";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://buildfarm.st.ewi.tudelft.nl/releases/strategoxt/java-front-0.9pre17376-qi43zwhy/java-front-0.9pre17376.tar.gz;
    md5 = "fec70158b110c77a2e5db29676438029";
  };

  inherit aterm sdf strategoxt;
  buildInputs = [pkgconfig aterm sdf strategoxt];
}
