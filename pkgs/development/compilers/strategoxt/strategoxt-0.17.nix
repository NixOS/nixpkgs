{stdenv, fetchurl, aterm, sdf, pkgconfig}:

stdenv.mkDerivation {

  name = "strategoxt-0.17";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://buildfarm.st.ewi.tudelft.nl/releases/strategoxt/strategoxt-0.17M3pre17099/strategoxt-0.17M3pre17099.tar.gz;
    md5 = "fc9bc3cb6d80bfa6ee1fadd2dd828c72";
  };

  inherit aterm sdf;
  buildInputs = [pkgconfig aterm sdf];
}
