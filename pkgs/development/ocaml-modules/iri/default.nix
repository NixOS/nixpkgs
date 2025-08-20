{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  sedlex,
  uunf,
  uutf,
}:

buildDunePackage rec {
  pname = "iri";
  version = "1.0.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "ocaml-iri";
    rev = version;
    hash = "sha256-6Q7qPezmdcO6JSevWl55XAxFuIROZNDrMkYw8VRR7qg=";
  };

  propagatedBuildInputs = [
    sedlex
    uunf
    uutf
  ];

  meta = {
    description = "IRI (RFC3987) native OCaml implementation";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
