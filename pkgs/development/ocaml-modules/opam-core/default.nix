{ stdenv, fetchFromGitHub, buildDunePackage
, cppo, ocamlgraph, opam-file-format, re }:

buildDunePackage rec {
  pname = "opam-core";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "opam";
    rev = version;
    sha256 = "1p719ccn9wnzk6impsnwr809yh507h8f37dx9nn64b1hsyb5z8ax";
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
