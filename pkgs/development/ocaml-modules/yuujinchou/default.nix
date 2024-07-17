{
  lib,
  ocaml,
  fetchFromGitHub,
  buildDunePackage,
  algaeff,
  bwd,
  qcheck-alcotest,
}:

let
  params =
    if lib.versionAtLeast ocaml.version "5.0" then
      {
        version = "5.1.0";
        hash = "sha256-J3qkytgJkk2gT83KJ47nNM4cXqVHbx4iTPK+fLwR7Wk=";
        propagatedBuildInputs = [
          algaeff
          bwd
        ];
      }
    else
      {
        version = "2.0.0";
        hash = "sha256:1nhz44cyipy922anzml856532m73nn0g7iwkg79yzhq6yb87109w";
      };
in

buildDunePackage rec {
  pname = "yuujinchou";
  inherit (params) version;

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = pname;
    rev = version;
    inherit (params) hash;
  };

  propagatedBuildInputs = params.propagatedBuildInputs or [ ];

  doCheck = true;
  checkInputs = [ qcheck-alcotest ];

  meta = {
    description = "Name pattern combinators";
    homepage = "https://github.com/RedPRL/yuujinchou";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
