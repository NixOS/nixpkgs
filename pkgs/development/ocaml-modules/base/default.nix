{ stdenv, fetchurl, ocaml, jbuilder, findlib }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "base is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-base-0.9.0";

  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/v0.9/files/base-v0.9.0.tar.gz;
    sha256 = "0pdpa3hflbqn978ppvv5y08cjya0k8xpf1h0kcak6bdrmnmiwlyx";
  };

  buildInputs = [ ocaml jbuilder findlib ];

  inherit (jbuilder) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
    homepage = https://github.com/janestreet/base;
    description = "Full standard library replacement for OCaml";
  };
}
