{ stdenv, fetchFromGitHub, buildDunePackage
, cppo, ocamlgraph, opam-file-format, re }:

buildDunePackage rec {
  pname = "opam-core";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "opam";
    rev = version;
    sha256 = "0pf2smq2sdcxryq5i87hz3dv05pb3zasb1is3kxq1pi1s4cn55mx";
  };

  buildInputs = [
    cppo
  ];

  propagatedBuildInputs = [
    ocamlgraph
    opam-file-format
    re
  ];

  enable_checks = "no";

  meta = {
    description = "Small standard library extensions, and generic system interaction modules used by opam.";
    license = stdenv.lib.licenses.lgpl2;
  };
}
