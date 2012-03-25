{stdenv, fetchurl, sqlite, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.5.8";
in

stdenv.mkDerivation {
  name = "ocaml-sqlite3-${version}";

  src = fetchurl {
    url = "http://hg.ocaml.info/release/ocaml-sqlite3/archive/" +
          "release-${version}.tar.bz2";
    sha256 = "0fqbxm90mc2gk6jp9p8s53kay0hbcd0qc0adq8znanz99n8zqp53";
  };

  buildInputs = [ocaml findlib];

  configureFlags = "--with-sqlite3=${sqlite}";

  preConfigure = ''
    export OCAMLPATH=$OCAMLPATH:$OCAMLFIND_DESTDIR
    mkdir -p $out/bin
  '';

  createFindlibDestdir = true;

  meta = {
    homepage = "http://ocaml.info/home/ocaml_sources.html#ocaml-sqlite3";
    description = "OCaml bindings to the SQLite 3 database access library";
    license = "MIT/X11";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
