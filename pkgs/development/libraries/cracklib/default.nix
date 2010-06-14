{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cracklib-2.8.16";

  #builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://sourceforge/cracklib/${name}.tar.gz";
    sha256 = "1g3mchdvra9nihxlkl3rdz96as3xnfw5m59hmr5k17l7qa9a8fpw";
  };

  #dicts = fetchurl {
  #  url = http://nixos.org/tarballs/cracklib-words.gz;
  #  md5 = "d18e670e5df560a8745e1b4dede8f84f";
  #};

  meta = {
    homepage = http://sourceforge.net/projects/cracklib;
    description = "A library for checking the strength of passwords";
  };
}
