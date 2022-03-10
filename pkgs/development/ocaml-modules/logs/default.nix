{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild
, topkg, result, lwt, cmdliner, fmt
, js_of_ocaml
, jsooSupport ? true
}:
let
  pname = "logs";
  webpage = "https://erratique.ch/software/${pname}";
in

if !lib.versionAtLeast ocaml.version "4.03"
then throw "logs is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1jnmd675wmsmdwyb5mx5b0ac66g4c6gpv5s4mrx2j6pb0wla1x46";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ fmt cmdliner lwt topkg ]
    ++ lib.optional jsooSupport js_of_ocaml;
  propagatedBuildInputs = [ result ];

  strictDeps = true;

  buildPhase = "${topkg.run} build --with-js_of_ocaml ${lib.boolToString jsooSupport}";

  inherit (topkg) installPhase;

  meta = with lib; {
    description = "Logging infrastructure for OCaml";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
