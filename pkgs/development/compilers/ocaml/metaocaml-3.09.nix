{ lib, stdenv, fetchurl, xlibsWrapper, ncurses }:

stdenv.mkDerivation ({

  pname = "metaocaml";
  version = "3.09-alpha-30";

  src = fetchurl {
    url = "http://www.metaocaml.org/dist/old/MetaOCaml_309_alpha_030.tar.gz";
    sha256 = "0migbn0zwfb7yb24dy7qfqi19sv3drqcv4369xi7xzpds2cs35fd";
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
    homepage = "http://www.metaocaml.org/";
    license = with lib.licenses; [ qpl lgpl2 ];
    description = "A compiled, type-safe, multi-stage programming language";
    broken = true;
  };

})
