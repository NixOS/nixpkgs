args: with args;

stdenv.mkDerivation {
  name = "gmm-svn";
  src = svnSrc "gmm" "e206834b273e271c174940a2bef7b899729d79bf78f0f63a759174b0ec121b10";
  buildInputs = [ cmake ];
}
