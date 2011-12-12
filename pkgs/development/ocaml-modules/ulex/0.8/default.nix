{stdenv, fetchurl, ocaml, findlib, camlp5 }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.8";
  pname = "ulex";

in

stdenv.mkDerivation {
  name = "${pname}-${version}";

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
    description = "ulex is a lexer generator for Unicode and OCaml";
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
