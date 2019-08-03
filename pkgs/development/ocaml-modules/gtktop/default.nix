{ stdenv, fetchurl, ocaml, camlp4, findlib, lablgtk-extras }:

let pname = "gtktop-2.0"; in

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml-${pname}";

  src = fetchurl {
    url = "http://zoggy.github.io/gtktop/${pname}.tar.gz";
    sha256 = "0cpmnavvham9mwxknm6df90g9qxabcvn2kfwlf9mncqa0z3rknz6";
  };

  buildInputs = [ ocaml camlp4 findlib ];
  propagatedBuildInputs = [ lablgtk-extras ];

  createFindlibDestdir = true;

  meta = {
    homepage = http://zoggy.github.io/gtktop/;
    description = "A small OCaml library to ease the creation of graphical toplevels";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
