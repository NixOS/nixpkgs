args: with args;

stdenv.mkDerivation {
  name = "gmm-svn";
  src = svnSrc "gmm" "0qvx9jf17z0mpwy8k6w6bla94gkkslkiv5w98aajfcq34n0zxcpc";
  buildInputs = [ cmake ];
}
