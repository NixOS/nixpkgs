{ lib, fetchurl, buildDunePackage
, gtkSupport ? true
, lablgtk, stdlib-shims
}:

buildDunePackage rec {
  pname = "ocamlgraph";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/backtracking/ocamlgraph/releases/download/${version}/ocamlgraph-${version}.tbz";
    sha256 = "sha256-IP4md5feUyIIik37UjibLqBReHlSqKT27XD8tpdIJgk=";
  };

  useDune2 = true;

  buildInputs = [ stdlib-shims ] ++ lib.optional gtkSupport lablgtk;

  meta = with lib; {
    homepage = "http://ocamlgraph.lri.fr/";
    downloadPage = "https://github.com/backtracking/ocamlgraph";
    description = "Graph library for Objective Caml";
    license = licenses.gpl2Oss;
    maintainers = with maintainers; [ kkallio ];
  };
}
