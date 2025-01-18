{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
  fmt,
  menhir,
  re,
}:

buildDunePackage rec {
  pname = "graphql_parser";
  version = "0.14.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/andreas/ocaml-graphql-server/releases/download/${version}/graphql-${version}.tbz";
    sha256 = "sha256-v4v1ueF+NV7LvYIVinaf4rE450Z1P9OiMAito6/NHAY=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    fmt
    re
  ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/andreas/ocaml-graphql-server";
    description = "Library for parsing GraphQL queries";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };

}
