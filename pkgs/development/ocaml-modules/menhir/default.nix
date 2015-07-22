{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "menhir-20140422";

  src = fetchurl {
    url = http://pauillac.inria.fr/~fpottier/menhir/menhir-20140422.tar.gz;
    sha256 = "1ki1f2id6a14h9xpv2k8yb6px7dyw8cvwh39csyzj4qpzx7wia0d";
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

  meta = with stdenv.lib; {
    homepage = http://pauillac.inria.fr/~fpottier/menhir/;
    description = "A LR(1) parser generator for OCaml";
    longDescription = ''
      Menhir is a LR(1) parser generator for the Objective Caml programming
      language.  That is, Menhir compiles LR(1) grammar specifications down
      to OCaml code.  Menhir was designed and implemented by François Pottier
      and Yann Régis-Gianas.
    '';
    license = with licenses; [
      qpl /* generator */
      lgpl2 /* library */
    ];
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [ z77z ];
  };
}
