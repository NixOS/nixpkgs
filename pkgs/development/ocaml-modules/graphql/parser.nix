{ lib, buildDunePackage, fetchurl, alcotest, fmt, menhir, re }:

buildDunePackage rec {
  pname = "graphql_parser";
  version = "0.13.0";

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/andreas/ocaml-graphql-server/releases/download/${version}/graphql-${version}.tbz";
    sha256 = "0gb5y99ph0nz5y3pc1gxq1py4wji2hyf2ydbp0hv23v00n50hpsm";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ fmt re ];

  checkInputs = lib.optional doCheck alcotest;

  doCheck = true;

  meta = {
    homepage = "https://github.com/andreas/ocaml-graphql-server";
    description = "Library for parsing GraphQL queries";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
