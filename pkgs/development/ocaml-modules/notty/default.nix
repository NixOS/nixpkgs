{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg, ocb-stubblr
, result, uucp, uuseg, uutf
, lwt     ? null }:

with lib;

if versionOlder ocaml.version "4.05"
|| versionAtLeast ocaml.version "4.14"
then throw "notty is not available for OCaml ${ocaml.version}"
else

let withLwt = lwt != null; in

stdenv.mkDerivation rec {
  version = "0.2.2";
  pname = "ocaml${ocaml.version}-notty";

  src = fetchurl {
    url = "https://github.com/pqwy/notty/releases/download/v${version}/notty-${version}.tbz";
    sha256 = "1y3hx8zjri3x50nyiqal5gak1sw54gw3xssrqbj7srinvkdmrz1q";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ ocb-stubblr topkg ocamlbuild ];
  propagatedBuildInputs = [ result uucp uuseg uutf ] ++
                          optional withLwt lwt;

  strictDeps = true;

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
