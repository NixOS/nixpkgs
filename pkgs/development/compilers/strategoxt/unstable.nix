{stdenv, fetchurl, aterm, sdf}:

stdenv.mkDerivation {
  name = "strategoxt-unstable-7462";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/stratego/strategoxt-0.12pre7462/strategoxt-0.12pre7462.tar.gz;
    md5 = "c86495e8eb1d91421a8e20a65afded3b";
  };

  inherit aterm;
  inherit (sdf) sglr pgen ptsupport asflibrary;

  buildInputs = [aterm sdf.pgen];
}
