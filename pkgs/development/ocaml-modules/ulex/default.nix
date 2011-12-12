{stdenv, fetchurl, ocaml, findlib }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.1";
  pname = "ulex";

in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.cduce.org/download/${pname}-${version}.tar.gz";
    sha256 = "0fjlkwps14adfgxdrbb4yg65fhyimplvjjs1xqj5np197cig67x0";
  };

  createFindlibDestdir = true;

  buildInputs = [ocaml findlib];

  buildFlags = "all all.opt";

  meta = {
    homepage = http://www.cduce.org/download.html;
    description = "ulex is a lexer generator for Unicode and OCaml";
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
