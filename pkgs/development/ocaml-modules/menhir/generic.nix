{ version, sha256, stdenv, fetchurl, ocaml, findlib }:

stdenv.mkDerivation {
  name = "menhir-${version}";

  src = fetchurl {
    url = "http://pauillac.inria.fr/~fpottier/menhir/menhir-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ ocaml findlib ];

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
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ z77z ];
  };
}
