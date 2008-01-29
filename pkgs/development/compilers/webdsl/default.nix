{stdenv, fetchurl, aterm, sdf, strategoxt, pkgconfig, javafront}:

stdenv.mkDerivation {
  name = "webdsl-7.12pre876";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://buildfarm.st.ewi.tudelft.nl/releases/strategoxt/webdsl-7.12pre876-g60njq3p/webdsl-7.12pre876.tar.gz;
    md5 = "7cd8709b02e03da74d90f8f8388e8d01";
  };

  inherit aterm sdf strategoxt javafront;
  buildInputs = [pkgconfig aterm sdf strategoxt javafront];
}
