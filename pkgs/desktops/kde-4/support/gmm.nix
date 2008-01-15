args: with args;

stdenv.mkDerivation {
  name = "gmm-svn";
  src = svnSrc "gmm" "1hxc6ymrjccz4mnix44fwpkmv8fvg5y5a9j3y6liz37wj87snnxd";
  buildInputs = [ cmake ];
}
