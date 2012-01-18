{ stdenv, fetchurl, x11, ncurses }:

stdenv.mkDerivation (rec {
  
  name = "metaocaml-3.09-alpha-30";
  
  src = fetchurl {
    url = "http://www.metaocaml.org/dist/old/MetaOCaml_309_alpha_030.tar.gz";
    sha256 = "0migbn0zwfb7yb24dy7qfqi19sv3drqcv4369xi7xzpds2cs35fd";
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
  postBuild = ''
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
  '';

  meta = {
    homepage = http://www.metaocaml.org/;
    license = "QPL, LGPL2 (library part)";
    desctiption = "A compiled, type-safe, multi-stage programming language";
  };

})
