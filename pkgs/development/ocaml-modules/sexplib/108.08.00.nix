{stdenv, fetchurl, ocaml, findlib, type_conv, camlp4}:

if !stdenv.lib.versionAtLeast ocaml.version "3.12"
|| stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "sexlib-108.08.00 is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation {
  name = "ocaml-sexplib-108.08.00";

  src = fetchurl {
    url = https://ocaml.janestreet.com/ocaml-core/108.08.00/individual/sexplib-108.08.00.tar.gz;
    sha256 = "11z1k1d7dbb5m957klgalimpr0r602xp5zkkbgbffib1bphasarg";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [type_conv camlp4];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    branch = "108";
    homepage = https://ocaml.janestreet.com/;
    description = "Library for serializing OCaml values to and from S-expressions";
    license = licenses.asl20;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
