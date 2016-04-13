{ stdenv, fetchFromGitHub, ocaml, findlib }:

let version = "1.1"; in

stdenv.mkDerivation {
  name = "ocaml-result-${version}";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "result";
    rev = "${version}";
    sha256 = "05y07rxdbkaxsc8cy458y00gq05i8gp35hhwg1b757mam21ccxxz";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/janestreet/result;
    description = "Compatibility Result module";
    longDescription = ''
      Projects that want to use the new result type defined in OCaml >= 4.03
      while staying compatible with older version of OCaml should use the
      Result module defined in this library.
    '';
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
  };
}
