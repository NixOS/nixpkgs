{ lib, stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, menhir, yojson, ulex, pprint, fix, functory }:

if lib.versionAtLeast ocaml.version "4.06"
then throw "mezzo is not available for OCaml ${ocaml.version}"
else

let
  check-ocaml-version = with lib; versionAtLeast (getVersion ocaml);
in

assert check-ocaml-version "4";

stdenv.mkDerivation {

  name = "mezzo-0.0.m8";

  src = fetchFromGitHub {
    owner = "protz";
    repo = "mezzo";
    rev = "m8";
    sha256 = "0yck5r6di0935s3iy2mm9538jkf77ssr789qb06ms7sivd7g3ip6";
  };

  buildInputs = [ ocaml findlib ocamlbuild yojson menhir ulex pprint fix functory ];

  # Sets warning 3 as non-fatal
  prePatch = lib.optionalString (check-ocaml-version "4.02") ''
    substituteInPlace myocamlbuild.pre.ml \
    --replace '@1..3' '@1..2+3'
  '';

  createFindlibDestdir = true;

  postInstall = ''
    mkdir $out/bin
    cp mezzo $out/bin/
  '';

  meta = with lib; {
    homepage = "http://protz.github.io/mezzo/";
    description = "A programming language in the ML tradition, which places strong emphasis on the control of aliasing and access to mutable memory";
    license = licenses.gpl2;
    platforms = ocaml.meta.platforms or [];
  };
}


