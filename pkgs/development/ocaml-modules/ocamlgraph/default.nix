{stdenv, fetchurl, ocaml, findlib, ocamlPackages }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.8.6";
in

stdenv.mkDerivation {
  name = "ocamlgraph-${version}";

  src = fetchurl {
    url = "http://ocamlgraph.lri.fr/download/ocamlgraph-${version}.tar.gz";
    sha256 = "1vyvy9cazv1grh0xn0j47w8bnhw93jbn29cqv34k1r0px16yyxdx";
  };

  buildInputs = [ ocaml findlib ocamlPackages.lablgtk ocamlPackages.camlp4 ];

  patches = ./destdir.patch;

  # some patching is required so that the lablgtk2 library is taken into account. It
  # does not reside in a subdirectory of the default library path, hence:
  # * configure looked in the wrong path
  # * ocaml needs that directory and the stubs directory as -I flag
  postPatch = ''
    sed -i 's@$(DESTDIR)$(OCAMLLIB)@$(DESTDIR)/lib/ocaml/${ocaml_version}/site-lib@' Makefile.in
    sed -i 's@$OCAMLLIB/lablgtk2@${ocamlPackages.lablgtk}/lib/ocaml/${ocaml_version}/site-lib/lablgtk2@' configure Makefile.in
    sed -i 's@+lablgtk2@${ocamlPackages.lablgtk}/lib/ocaml/${ocaml_version}/site-lib/lablgtk2 -I ${ocamlPackages.lablgtk}/lib/ocaml/${ocaml_version}/site-lib/stublibs@' configure Makefile.in editor/Makefile
  '';

  createFindlibDestdir = true;

  buildPhase = ''
    make all
    make install-findlib
    echo "breakhash2"
  '';

  meta = {
    homepage = http://ocamlgraph.lri.fr/;
    description = "Graph library for Objective Caml";
    license = stdenv.lib.licenses.gpl2Oss;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.kkallio
    ];
  };
}
