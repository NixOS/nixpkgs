{stdenv, fetchurl, aterm, sdf, strategoxt, pkgconfig}:

stdenv.mkDerivation {
  name = "strategoxt-utils-0.16";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/stratego/strategoxt-utils-0.16/strategoxt-utils-0.16.tar.gz;
    md5 = "a118d67e7a2f1eb61f0cfccbe61aa509";
  };

  inherit aterm sdf;
  buildInputs = [pkgconfig aterm sdf strategoxt];
}
