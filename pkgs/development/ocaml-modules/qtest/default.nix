{ stdenv, fetchzip, ocaml, oasis, findlib, ounit }:

let version = "2.0.1"; in

stdenv.mkDerivation {
  name = "ocaml-qtest-${version}";
  src = fetchzip {
    url = "https://github.com/vincent-hugot/iTeML/archive/v${version}.tar.gz";
    sha256 = "00sir7q7z78s22w8fzrgw9gqm7r8ww0bgwqxrq6nsbbclgxj9c6i";
  };

  buildInputs = [ ocaml oasis findlib ];
  propagatedBuildInputs = [ ounit ];

  buildPhase = "ocaml do.ml qtest build $out";
  createFindlibDestdir = true;
  installPhase = "ocaml do.ml qtest install $out";

  meta = {
    description = "Inline (Unit) Tests for OCaml (formerly “qtest”)";
    homepage = https://github.com/vincent-hugot/iTeML;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
