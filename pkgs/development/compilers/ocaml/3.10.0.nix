{ stdenv, fetchurl, x11, ncurses }:

stdenv.mkDerivation (rec {
  
  name = "ocaml-3.10.0";
  
  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-3.10/${name}.tar.bz2";
    sha256 = "1ihmx1civ78s7k2hfc05z1s9vbyx2qw7fg8lnbxnfd6zxkk8878d";
  };

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk" "-x11lib" x11];
  buildFlags = "world bootstrap world.opt";
  buildInputs = [x11 ncurses];
  installTargets = "install installopt"; 
  patchPhase = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '';

  meta = {
    homepage = http://caml.inria.fr/ocaml;
    license = "QPL, LGPL2 (library part)";
    desctiption = "Most popular variant of the Caml language";
  };

})
