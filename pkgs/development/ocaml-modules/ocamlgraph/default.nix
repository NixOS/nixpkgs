{stdenv, fetchurl, ocaml, findlib }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.8.1";
in

stdenv.mkDerivation {
  name = "ocamlgraph-${version}";

  src = fetchurl {
    url = "http://ocamlgraph.lri.fr/download/ocamlgraph-${version}.tar.gz";
    sha256 = "0hrba69wvw9b42irkvjf6q7zzw12v5nyyc33yaq3jlf1qbzqhqxs";
  };

  buildInputs = [ ocaml findlib ];

  patches = ./destdir.patch;

  postPatch = ''
    sed -i 's@$(DESTDIR)$(OCAMLLIB)/ocamlgraph@$(DESTDIR)/lib/ocaml/${ocaml_version}/site-lib/ocamlgraph@' Makefile.in
  '';

  createFindlibDestdir = true;

  buildPhase = ''
    make all
    make install-findlib
  '';

  meta = {
    homepage = http://ocamlgraph.lri.fr/;
    description = "ocamlgraph is a graph library for Objective Caml.";
    license = "GNU Library General Public License version 2, with the special exception on linking described in file LICENSE";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.kkallio
    ];
  };
}
