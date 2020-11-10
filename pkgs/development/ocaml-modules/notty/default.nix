{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, ocb-stubblr
, result, uucp, uuseg, uutf
, lwt     ? null }:

with stdenv.lib;

if !versionAtLeast ocaml.version "4.05"
then throw "notty is not available for OCaml ${ocaml.version}"
else

let withLwt = lwt != null; in

stdenv.mkDerivation rec {
  version = "0.2.2";
  name = "ocaml${ocaml.version}-notty-${version}";

  src = fetchurl {
    url = "https://github.com/pqwy/notty/releases/download/v${version}/notty-${version}.tbz";
    sha256 = "1y3hx8zjri3x50nyiqal5gak1sw54gw3xssrqbj7srinvkdmrz1q";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ocb-stubblr ];
  propagatedBuildInputs = [ result uucp uuseg uutf ] ++
                          optional withLwt lwt;

  buildPhase = topkg.buildPhase
  + " --with-lwt ${boolToString withLwt}";

  inherit (topkg) installPhase;

  meta = {
    homepage = "https://github.com/pqwy/notty";
    inherit (ocaml.meta) platforms;
    description = "Declarative terminal graphics for OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
