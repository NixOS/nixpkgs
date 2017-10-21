{ stdenv, fetchFromGitHub, ocaml, findlib }:

let version = "1.2"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-result-${version}";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "result";
    rev = "${version}";
    sha256 = "1jwzpcmxwgkfsbjz9zl59v12hf1vv4r9kiifancn9p8gm206g3g0";
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
