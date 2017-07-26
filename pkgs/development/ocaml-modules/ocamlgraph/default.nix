{stdenv, fetchurl, ocaml, findlib, lablgtk}:

stdenv.mkDerivation rec {
  name = "ocamlgraph-${version}";
  version = "1.8.7";

  src = fetchurl {
    url = "http://ocamlgraph.lri.fr/download/ocamlgraph-${version}.tar.gz";
    sha256 = "1845r537swjil2fcj7lgbibc2zybfwqqasrd2s7bncajs83cl1nz";
  };

  buildInputs = [ ocaml findlib lablgtk ];

  patches = ./destdir.patch;

  postPatch = ''
    sed -i 's@$(DESTDIR)$(OCAMLLIB)/ocamlgraph@$(DESTDIR)/lib/ocaml/${ocaml.version}/site-lib/ocamlgraph@' Makefile.in
    sed -i 's@OCAMLFINDDEST := -destdir $(DESTDIR)@@' Makefile.in
    sed -i 's@+lablgtk2@${lablgtk}/lib/ocaml/${ocaml.version}/site-lib/lablgtk2 -I ${lablgtk}/lib/ocaml/${ocaml.version}/site-lib/stublibs@' configure Makefile.in editor/Makefile
  '';

  createFindlibDestdir = true;

  buildPhase = ''
    make all
    make install-findlib
  '';

  meta = {
    homepage = http://ocamlgraph.lri.fr/;
    description = "Graph library for Objective Caml";
    license = stdenv.lib.licenses.gpl2Oss;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.kkallio
    ];
  };
}
