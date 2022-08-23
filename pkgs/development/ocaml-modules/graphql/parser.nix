{ lib, buildDunePackage, ocaml, fetchurl, alcotest, fmt, menhir, re }:

buildDunePackage rec {
  pname = "graphql_parser";
  version = "0.14.0";

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/andreas/ocaml-graphql-server/releases/download/${version}/graphql-${version}.tbz";
    sha256 = "sha256-v4v1ueF+NV7LvYIVinaf4rE450Z1P9OiMAito6/NHAY=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ fmt re ];

  checkInputs = [ alcotest ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/andreas/ocaml-graphql-server";
    description = "Library for parsing GraphQL queries";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
