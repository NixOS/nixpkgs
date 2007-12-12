args: with args;

stdenv.mkDerivation {
  name = "eigen-1.0.5";
  src = svnSrc "eigen" "0dr2gzrf17bdgxj4f9ibk7x5j7fqwwjsl800dzfvrhgj6v1mxm4x";
  buildInputs = [ cmake ];
}
