{ lib, fetchFromGitHub, buildDunePackage, ocaml, markup, ounit2 }:

buildDunePackage rec {
  pname = "lambdasoup";
  version = "0.7.3";

  minimalOCamlVersion = "4.02";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    sha256 = "sha256:1wclkn1pl0d150dw0xswb29jc7y1q9mhipff1pnsc1hli3pyvvb7";
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
