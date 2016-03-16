{ stdenv, fetchurl, ocaml, findlib, camlp4 }:

stdenv.mkDerivation {
  name = "ocaml-config-file-1.2";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1387/config-file-1.2.tar.gz;
    sha256 = "1b02yxcnsjhr05ssh2br2ka4hxsjpdw34ldl3nk33wfnkwk7g67q";
  };

  buildInputs = [ ocaml findlib camlp4 ];

  createFindlibDestdir = true;

  meta = {
    homepage = http://config-file.forge.ocamlcore.org/;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    description = "An OCaml library used to manage the configuration file(s) of an application";
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
