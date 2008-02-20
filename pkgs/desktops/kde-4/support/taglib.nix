args: with args;

stdenv.mkDerivation {
  name = "taglib-1.4svn";
  src = svnSrc "taglib" "1myfgykflbs3l1mrzg4iv8rb1mbd0vpmzl5dnnslfi9b0xg6ydip";
  buildInputs = [ cmake zlib ];
}
