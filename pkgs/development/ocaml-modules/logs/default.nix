{ stdenv, fetchurl, ocaml, findlib, ocamlbuild
, topkg, result, lwt, cmdliner, fmt }:
let
  pname = "logs";
  webpage = "https://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01.0";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "0.6.3";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1lkhr7i44xw4kpfbhgj3rbqy3dv5bfm4kyrbl8a9rfafddcxlwss";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg fmt cmdliner lwt ];
  propagatedBuildInputs = [ result ];

  buildPhase = "${topkg.run} build --with-js_of_ocaml false";

  inherit (topkg) installPhase;

  meta = with stdenv.lib; {
    description = "Logging infrastructure for OCaml";
    homepage = "${webpage}";
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
