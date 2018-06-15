{ stdenv, fetchurl, ocaml, findlib, ocamlbuild }:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "2.0";
    url = http://forge.ocamlcore.org/frs/download.php/1615/ocaml-safepass-2.0.tgz;
    sha256 = "1zxx3wcyzhxxvm5w9c21y7hpa11h67paaaz9mfsyiqk6fs6hcvmw";
  } else {
    version = "1.3";
    url = http://forge.ocamlcore.org/frs/download.php/1432/ocaml-safepass-1.3.tgz;
    sha256 = "0lb8xbpyc5d1zml7s7mmcr6y2ipwdp7qz73lkv9asy7dyi6cj15g";
  };
in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-safepass-${param.version}";
  src = fetchurl {
    inherit (param) url sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  meta = {
    homepage = http://ocaml-safepass.forge.ocamlcore.org/;
    description = "An OCaml library offering facilities for the safe storage of user passwords";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
