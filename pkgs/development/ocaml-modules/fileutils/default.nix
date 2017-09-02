{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, ounit }:

stdenv.mkDerivation {
  name = "ocaml-fileutils-0.5.2";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1695/ocaml-fileutils-0.5.2.tar.gz;
    sha256 = "06l8hva3jmb2b7n4aa84dhhh1lr2mj8632gz4q83glc00khkn1vv";
  };

  buildInputs = [ ocaml findlib ocamlbuild ounit ];

  configureFlags = "--enable-tests";
  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;

  preInstall = "make doc";

  meta = {
    homepage = https://forge.ocamlcore.org/projects/ocaml-fileutils/;
    platforms = ocaml.meta.platforms or [];
    description = "Library to provide pure OCaml functions to manipulate real file (POSIX like) and filename";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
