{ stdenv, fetchFromGitHub, ocaml, findlib, qtest, ounit }:

let version = "0.6"; in

stdenv.mkDerivation {
  name = "ocaml-sequence-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "sequence";
    rev = "${version}";
    sha256 = "0mky5qas3br2x4y14dzcky212z624ydqnx8mw8w00x0c1xjpafkb";
  };

  buildInputs = [ ocaml findlib qtest ounit ];

  configureFlags = [
    "--enable-tests"
  ];

  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;

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
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
