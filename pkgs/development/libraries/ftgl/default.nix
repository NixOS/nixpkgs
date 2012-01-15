{stdenv, fetchurl, freetype, mesa}:

let
  name = "ftgl-2.1.3-rc5";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/ftgl/${name}.tar.gz";
    sha256 = "0nsn4s6vnv5xcgxcw6q031amvh2zfj2smy1r5mbnjj2548hxcn2l";
  };

  buildInputs = [freetype mesa];

}
