{ stdenv, fetchurl, ocaml, findlib }:

stdenv.mkDerivation {
  name = "ocaml-safepass-1.3";
  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1432/ocaml-safepass-1.3.tgz;
    sha256 = "0lb8xbpyc5d1zml7s7mmcr6y2ipwdp7qz73lkv9asy7dyi6cj15g";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = {
    homepage = http://ocaml-safepass.forge.ocamlcore.org/;
    description = "An OCaml library offering facilities for the safe storage of user passwords";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
