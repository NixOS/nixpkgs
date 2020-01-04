{ stdenv, fetchurl, xlibsWrapper, ncurses }:

stdenv.mkDerivation (rec {

  pname = "ocaml";
  version = "3.10.0";

  src = fetchurl {
    url = "https://caml.inria.fr/pub/distrib/ocaml-3.10/${pname}-${version}.tar.bz2";
    sha256 = "1ihmx1civ78s7k2hfc05z1s9vbyx2qw7fg8lnbxnfd6zxkk8878d";
  };

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk" "-x11lib" xlibsWrapper];
  buildFlags = [ "world" "bootstrap" "world.opt" ];
  buildInputs = [xlibsWrapper ncurses];
  installTargets = "install installopt";
  patchPhase = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '';
  postBuild = ''
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
  '';

  meta = {
    homepage = http://caml.inria.fr/ocaml;
    license = with stdenv.lib.licenses; [ qpl lgpl2 ];
    description = "Most popular variant of the Caml language";
    platforms = stdenv.lib.platforms.linux;
  };

})
