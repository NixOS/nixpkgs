{ stdenv, fetchurl, ocaml, findlib }:

stdenv.mkDerivation {
  name = "ocaml-fileutils-0.4.5";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1194/ocaml-fileutils-0.4.5.tar.gz;
    sha256 = "0rlqmcgjrfjihjgw5cfmack169cag8054gh5yrqph15av3lx5cra";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://forge.ocamlcore.org/projects/ocaml-fileutils/;
    platforms = ocaml.meta.platforms;
    description = "Library to provide pure OCaml functions to manipulate real file (POSIX like) and filename";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
