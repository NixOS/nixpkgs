{ stdenv, fetchzip, autoreconfHook, which, ocaml, findlib }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "bitv is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-bitv-${version}";
  version = "1.3";

  src = fetchzip {
    url = "https://github.com/backtracking/bitv/archive/${version}.tar.gz";
    sha256 = "0vkh1w9fpi5m1sgiqg6r38j3fqglhdajmbyiyr91113lrpljm75i";
  };

  buildInputs = [ autoreconfHook which ocaml findlib ];

  createFindlibDestdir = true;

  meta = {
    description = "A bit vector library for OCaml";
    license = stdenv.lib.licenses.lgpl21;
    homepage = https://github.com/backtracking/bitv;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
