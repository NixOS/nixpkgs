{ lib, fetchFromGitHub, buildDunePackage, ocaml, markup, ounit2 }:

buildDunePackage rec {
  pname = "lambdasoup";
  version = "0.7.2";

  minimumOCamlVersion = "4.02";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    sha256 = "0php51lyz3ll0psazjd59yw02xb9w84150gkyiwmn3fa0iq8nf7m";
  };

  propagatedBuildInputs = [ markup ];

  doCheck = lib.versionAtLeast ocaml.version "4.04";
  checkInputs = [ ounit2 ];

  meta = {
    description = "Functional HTML scraping and rewriting with CSS in OCaml";
    homepage = "https://aantron.github.io/lambdasoup/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
