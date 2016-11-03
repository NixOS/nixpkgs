{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, qtest, ounit }:

let version = "0.8"; in

stdenv.mkDerivation {
  name = "ocaml-sequence-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "sequence";
    rev = "${version}";
    sha256 = "1y9nkz6g4plnbk1pcdbvs7f719r48zxrp3gsaxyq1vg98i9h8qr3";
  };

  buildInputs = [ ocaml findlib ocamlbuild qtest ounit ];

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
    platforms = ocaml.meta.platforms or [];
  };
}
