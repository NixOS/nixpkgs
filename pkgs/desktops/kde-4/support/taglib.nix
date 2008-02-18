args: with args;

stdenv.mkDerivation {
  name = "taglib-1.4svn";
  src = svnSrc "taglib" "8921c905eb0273929c9ee5cf11e271fe12b443dabb2370e1471dfbdbbb75f853";
  buildInputs = [ cmake zlib ];
}
