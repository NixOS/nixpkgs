args: with args;

stdenv.mkDerivation {
  name = "taglib-1.4svn";
  src = svnSrc "taglib" "1wszymg4r3mm06wbxviqmnxra120kc1rxbk0a6kjrxjpyr8qcn2k";
  buildInputs = [ cmake zlib ];
}
