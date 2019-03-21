{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, ounit }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-fileutils-0.5.3";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1728/ocaml-fileutils-0.5.3.tar.gz;
    sha256 = "1rc4cqlvdhbs55i85zfbfhz938fsy4fj6kwlkfm3ra7bpwn8bmpd";
  };

  buildInputs = [ ocaml findlib ocamlbuild ounit ];

  configureFlags = [ "--enable-tests" ];
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
