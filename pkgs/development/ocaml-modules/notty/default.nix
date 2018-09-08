{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, ocb-stubblr
, result, uucp, uuseg, uutf
, lwt     ? null }:

with stdenv.lib;

if !versionAtLeast ocaml.version "4.03"
then throw "notty is not available for OCaml ${ocaml.version}"
else

let withLwt = lwt != null; in

stdenv.mkDerivation rec {
  version = "0.2.1";
  name = "ocaml${ocaml.version}-notty-${version}";

  src = fetchurl {
    url = "https://github.com/pqwy/notty/releases/download/v${version}/notty-${version}.tbz";
    sha256 = "0wdfmgx1mz77s7m451vy8r9i4iqwn7s7b39kpbpckf3w9417riq0";
  };

  unpackCmd = "tar -xjf $curSrc";

  buildInputs = [ ocaml findlib ocamlbuild topkg ocb-stubblr ];
  propagatedBuildInputs = [ result uucp uuseg uutf ] ++
                          optional withLwt lwt;

  buildPhase = topkg.buildPhase
  + " --with-lwt ${boolToString withLwt}";

  inherit (topkg) installPhase;

  meta = {
    homepage = https://github.com/pqwy/notty;
    inherit (ocaml.meta) platforms;
    description = "Declarative terminal graphics for OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
