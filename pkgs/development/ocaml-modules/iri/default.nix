{ stdenv, fetchFromGitLab, ocaml, findlib
, sedlex, uunf, uutf
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "iri is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "ocaml${ocaml.version}-iri-${version}";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "ocaml-iri";
    rev = version;
    sha256 = "0fsmfmzmyggm0h77a7mb0n41vqi6q4ln1xzsv72zbvysa7l8w84q";
  };

  buildInputs = [ ocaml findlib ];

  propagatedBuildInputs = [ sedlex uunf uutf ];

  createFindlibDestdir = true;

  meta = {
    description = "IRI (RFC3987) native OCaml implementation";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
