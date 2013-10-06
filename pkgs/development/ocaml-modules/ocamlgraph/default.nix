{stdenv, fetchurl, ocaml, findlib, ocamlPackages }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.8.2";
in

stdenv.mkDerivation {
  name = "ocamlgraph-${version}";

  src = fetchurl {
    url = "http://ocamlgraph.lri.fr/download/ocamlgraph-${version}.tar.gz";
    sha256 = "e54ae60cd977a032854166dad56348d0fb76c6cd8e03e960af455268f0c8b5a6";
  };

  buildInputs = [ ocaml findlib ocamlPackages.lablgtk ];

  patches = ./destdir.patch;

  # some patching is required so that the lablgtk2 library is taken into account. It
  # does not reside in a subdirectory of the default library path, hence:
  # * configure looked in the wrong path
  # * ocaml needs that directory and the stubs directory as -I flag
  postPatch = ''
    sed -i 's@$(DESTDIR)$(OCAMLLIB)/ocamlgraph@$(DESTDIR)/lib/ocaml/${ocaml_version}/site-lib/ocamlgraph@' Makefile.in
    sed -i 's@$OCAMLLIB/lablgtk2@${ocamlPackages.lablgtk}/lib/ocaml/${ocaml_version}/site-lib/lablgtk2@' configure Makefile.in
    sed -i 's@-I +lablgtk2@-I ${ocamlPackages.lablgtk}/lib/ocaml/${ocaml_version}/site-lib/lablgtk2 -I ${ocamlPackages.lablgtk}/lib/ocaml/${ocaml_version}/site-lib/stublibs@' configure Makefile.in editor/Makefile
  '';

  createFindlibDestdir = true;

  buildPhase = ''
    make all
    make install-findlib
  '';

  meta = {
    homepage = http://ocamlgraph.lri.fr/;
    description = "Graph library for Objective Caml";
    license = "GNU Library General Public License version 2, with the special exception on linking described in file LICENSE";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.kkallio
    ];
  };
}
