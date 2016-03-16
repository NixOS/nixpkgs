{ stdenv, fetchurl, ocaml, findlib, ounit }:

stdenv.mkDerivation {
  name = "ocaml-fileutils-0.5.0";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1531/ocaml-fileutils-0.5.0.tar.gz;
    sha256 = "0xs96nlrrm335mcsgsxnqzspiqyfn26b0jjxm72br7c7ax534n47";
  };

  buildInputs = [ ocaml findlib ounit ];

  configureFlags = "--enable-tests";
  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;

  preInstall = "make doc";

  meta = {
    homepage = https://forge.ocamlcore.org/projects/ocaml-fileutils/;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    description = "Library to provide pure OCaml functions to manipulate real file (POSIX like) and filename";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
