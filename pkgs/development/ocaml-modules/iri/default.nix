{ lib, buildDunePackage, fetchFromGitLab
, sedlex, uunf, uutf
}:

buildDunePackage rec {
  pname = "iri";
  version = "0.6.0";
  useDune2 = true;

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "ocaml-iri";
    rev = version;
    sha256 = "sha256:0zk8nnwcyljkc1a556byncv6cn1vqhk4267z1lm15flh1k7chyax";
  };

  propagatedBuildInputs = [ sedlex uunf uutf ];

  meta = {
    description = "IRI (RFC3987) native OCaml implementation";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
