{ stdenv, lib, fetchurl, ocaml, findlib
, gtkSupport ? true
, lablgtk
}:

stdenv.mkDerivation rec {
  pname = "ocamlgraph";
  version = "1.8.8";

  src = fetchurl {
    url = "http://ocamlgraph.lri.fr/download/ocamlgraph-${version}.tar.gz";
    sha256 = "0m9g16wrrr86gw4fz2fazrh8nkqms0n863w7ndcvrmyafgxvxsnr";
  };

  buildInputs = [ ocaml findlib ]
  ++ lib.optional gtkSupport lablgtk
  ;

  createFindlibDestdir = true;

  buildFlags =  [ "all" ];
  installTargets = [ "install-findlib" ];

  postInstall = lib.optionalString gtkSupport ''
    mkdir -p $out/bin
    cp dgraph/dgraph.opt $out/bin/graph-viewer
    cp editor/editor.opt $out/bin/graph-editor
  '';

  meta = {
    homepage = "http://ocamlgraph.lri.fr/";
    description = "Graph library for Objective Caml";
    license = lib.licenses.gpl2Oss;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      lib.maintainers.kkallio
    ];
  };
}
