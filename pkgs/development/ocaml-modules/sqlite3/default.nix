{stdenv, fetchurl, sqlite, ocaml, findlib, pkgconfig}:

stdenv.mkDerivation {
  name = "ocaml-sqlite3-2.0.4";

  src = fetchurl {
    url = https://bitbucket.org/mmottl/sqlite3-ocaml/downloads/sqlite3-ocaml-2.0.4.tar.gz;
    sha256 = "51ccb4c7a240eb40652c59e1770cfe1827dfa1eb926c969d19ff414aef4e80a1";
  };

  buildInputs = [ocaml findlib pkgconfig ];

  #configureFlags = "--with-sqlite3=${sqlite}";

  preConfigure = ''
    export PKG_CONFIG_PATH=${sqlite}/lib/pkgconfig/
    export OCAMLPATH=$OCAMLPATH:$OCAMLFIND_DESTDIR
    mkdir -p $out/bin
  '';

  createFindlibDestdir = true;

  meta = {
    homepage = https://bitbucket.org/mmottl/sqlite3-ocaml;
    description = "OCaml bindings to the SQLite 3 database access library";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
