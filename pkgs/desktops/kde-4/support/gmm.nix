args: with args;

stdenv.mkDerivation {
  name = "gmm-svn";
  src = svnSrc "gmm" "08j40y85dprs9ddzsddimrhssnz08fafq6nhn40l59ddbvvir0gy";
  buildInputs = [ cmake ];
}
