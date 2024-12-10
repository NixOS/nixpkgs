{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  camlp-streams,
  markup,
  ounit2,
}:

buildDunePackage rec {
  pname = "lambdasoup";
  version = "1.0.0";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    hash = "sha256-PZkhN5vkkLu8A3gYrh5O+nq9wFtig0Q4qD8zLGUGTRI=";
  };

  propagatedBuildInputs = [
    camlp-streams
    markup
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit2 ];

  meta = {
    description = "Functional HTML scraping and rewriting with CSS in OCaml";
    homepage = "https://aantron.github.io/lambdasoup/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
