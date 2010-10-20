{stdenv, fetchurl, freetype, mesa}:
 
stdenv.mkDerivation {
  name = "ftgl-2.1.3-rc5";
  
  src = fetchurl {
    url = mirror://sourceforge/ftgl/files/FTGL%20Source/2.1.3%7Erc5/ftgl-2.1.3-rc5.tar.gz ;
    sha256 = "0nsn4s6vnv5xcgxcw6q031amvh2zfj2smy1r5mbnjj2548hxcn2l";
  };
  
  buildInputs = [freetype mesa];

}
