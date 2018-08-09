{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder, qtest, result }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "sequence is not available for OCaml ${ocaml.version}"
else

let version = "1.1"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-sequence-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "sequence";
    rev = version;
    sha256 = "08j37nldw47syq3yw4mzhhvya43knl0d7biddp0q9hwbaxhzgi44";
  };

  buildInputs = [ ocaml findlib jbuilder qtest ];
  propagatedBuildInputs = [ result ];

  doCheck = true;
  checkPhase = "jbuilder runtest";

  inherit (jbuilder) installPhase;

  meta = {
    homepage = https://github.com/c-cube/sequence;
    description = "Simple sequence (iterator) datatype and combinators";
    longDescription = ''
      Simple sequence datatype, intended to transfer a finite number of
      elements from one data structure to another. Some transformations on sequences,
      like `filter`, `map`, `take`, `drop` and `append` can be performed before the
      sequence is iterated/folded on.
    '';
    license = stdenv.lib.licenses.bsd2;
    platforms = ocaml.meta.platforms or [];
  };
}
