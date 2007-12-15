args: with args;

stdenv.mkDerivation {
  name = "eigen-1.0.5";
  src = svnSrc "eigen" "1wh6kdmzsxmk6byp4rq91pz4rfr7hnh17g8f415p0ywxalg6pfkg";
  buildInputs = [ cmake ];
}
