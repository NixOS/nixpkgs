args: with args;

stdenv.mkDerivation {
  name = "eigen-1.0.5";
  src = svnSrc "eigen" "6fba6b1e559d7b704b200ebd13a08527bb4cfe0d096772fd32b376fd6b9b06f2";
  buildInputs = [ cmake ];
}
