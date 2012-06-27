{stdenv, fetchurl, sqlite, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-sqlite3-1.6.3";

  src = fetchurl {
    url = https://bitbucket.org/mmottl/sqlite3-ocaml/downloads/sqlite3-ocaml-1.6.3.tar.gz;
    sha256 = "004wysf80bmb8r4yaa648v0bqrh2ry3kzy763gdksw4n15blghv5";
  };

  buildInputs = [ocaml findlib];

  configureFlags = "--with-sqlite3=${sqlite}";

  preConfigure = ''
    export OCAMLPATH=$OCAMLPATH:$OCAMLFIND_DESTDIR
    mkdir -p $out/bin
  '';

  createFindlibDestdir = true;

  meta = {
    homepage = https://bitbucket.org/mmottl/sqlite3-ocaml;
    description = "OCaml bindings to the SQLite 3 database access library";
    license = "MIT/X11";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
