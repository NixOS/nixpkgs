args: with args;

stdenv.mkDerivation {
  name = "taglib-1.4svn";
  src = svnSrc "taglib" "0jmy1mldpjqnq8ap3ynwagxpjcfxzbisa4qd6zdwlwcm8zb54rak";
  buildInputs = [ cmake zlib ];
}
