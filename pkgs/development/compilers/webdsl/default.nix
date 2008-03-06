{stdenv, fetchurl, aterm, sdf, strategoxt, pkgconfig, javafront}:

stdenv.mkDerivation {
  name = "webdsl-8.2pre1006";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://buildfarm.st.ewi.tudelft.nl/releases/strategoxt/webdsl-8.2pre1006-c8h623yn/webdsl-8.2.tar.gz;
    md5 = "07c2471c961acc6467c55594e49da7c1";
  };

  inherit aterm sdf strategoxt javafront;
  buildInputs = [pkgconfig aterm sdf strategoxt javafront];
}
