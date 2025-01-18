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
  version = "1.1.1";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    hash = "sha256-+d1JPU7OyQgt8pDTlwZraqPHH+OBQD1ycsELKpHT95Y=";
  };

  propagatedBuildInputs = [
    camlp-streams
    markup
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit2 ];

  meta = with lib; {
    description = "Functional HTML scraping and rewriting with CSS in OCaml";
    homepage = "https://aantron.github.io/lambdasoup/";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };

}
