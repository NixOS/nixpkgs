{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "menhir-20130116";

  src = fetchurl {
    url = http://pauillac.inria.fr/~fpottier/menhir/menhir-20130116.tar.gz;
    sha256 = "65cd9e4f813c62697c60c344963ca11bd461169f574ba3a866c2691541cb4682";
  };

  buildInputs = [ocaml findlib];

  createFindlibDestdir = true;

  preBuild = ''
    #Fix makefiles.
    RM=$(type -p rm)
    CHMOD=$(type -p chmod)
    ENV=$(type -p env)
    for f in src/Makefile demos/OMakefile* demos/Makefile* demos/ocamldep.wrapper
    do
      substituteInPlace $f \
        --replace /bin/rm $RM \
	--replace /bin/chmod $CHMOD \
	--replace /usr/bin/env $ENV
    done

    export PREFIX=$out
  '';

  meta = {
    homepage = http://pauillac.inria.fr/~fpottier/menhir/;
    description = "A LR(1) parser generator for OCaml";
    longDescription = ''
      Menhir is a LR(1) parser generator for the Objective Caml programming
      language.  That is, Menhir compiles LR(1) grammar specifications down
      to OCaml code.  Menhir was designed and implemented by François Pottier
      and Yann Régis-Gianas.
    '';
    license = [ "QPL" /* generator */ "LGPLv2" /* library */ ];
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
