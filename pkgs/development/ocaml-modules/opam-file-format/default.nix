{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "opam-file-format";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ka9pMYB99kM+5X7wf9F13gUrjouZucGevvkSY0TaXGg=";
  };

  useDune2 = true;

  meta = with lib; {
    description = "Parser and printer for the opam file syntax";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl ];
    homepage = "https://github.com/ocaml/opam-file-format/";
    changelog = "https://github.com/ocaml/opam-file-format/raw/${version}/CHANGES";
  };
}
