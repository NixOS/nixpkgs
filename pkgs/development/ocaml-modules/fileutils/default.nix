{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, ounit }:

stdenv.mkDerivation {
  name = "ocaml-fileutils-0.5.1";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1651/ocaml-fileutils-0.5.1.tar.gz;
    sha256 = "0g6zx2rcvacklxyli19ixcf6ich9ipxsps4k3jz98f5zlaab0a7g";
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
