{stdenv, fetchurl, ocaml, findlib, camlp5 }:

let
  pname = "ulex";
in

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "ulex-0.8 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.8";

  src = fetchurl {
    url = "http://www.cduce.org/download/old/${pname}-${version}.tar.gz";
    sha256 = "19faabg8hzz155xlzmjwsl59d7slahb5m1l9zh1fqvvpp81r26cp";
  };

  buildInputs = [ocaml findlib camlp5];

  createFindlibDestdir = true;

  patches = [ ./meta_version.patch ./camlp5.patch ];

  propagatedBuildInputs = [ camlp5 ];

  buildFlags = "all all.opt";

  meta = {
    homepage = http://www.cduce.org/download.html;
    description = "A lexer generator for Unicode and OCaml";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
