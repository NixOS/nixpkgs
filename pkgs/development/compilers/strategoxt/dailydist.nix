{stdenv, fetchurl, aterm, sdf}:

stdenv.mkDerivation {
  name = "strategoxt-0.11pre-6529";
  builder = ./new-builder.sh;
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~mbravenb/dailydist/strategoxt/src/strategoxt-0.11pre-6529.tar.gz;
    md5 = "e14a548c5b871d1d99e2fcf7dc1c7754";
  };
  inherit aterm;
  inherit (sdf) ptsupport asflibrary pgen sglr;
  buildInputs = [aterm sdf.ptsupport sdf.sdfsupport sdf.pgen sdf.sglr];
}
