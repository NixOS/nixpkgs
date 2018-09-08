{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "psq is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-psq-${version}";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/pqwy/psq/releases/download/v${version}/psq-${version}.tbz";
    sha256 = "08ghgdivbjrxnaqc3hsb69mr9s2ql5ds0fb97b7z6zimzqibz6lp";
  };

  unpackCmd = "tar -xjf $curSrc";

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "Functional Priority Search Queues for OCaml";
    homepage = https://github.com/pqwy/psq;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.isc;
    inherit (ocaml.meta) platforms;
  };
}
