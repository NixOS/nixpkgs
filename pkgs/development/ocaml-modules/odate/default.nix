{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
}:

buildDunePackage rec {
  pname = "odate";
  version = "0.7";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "hhugo";
    repo = pname;
    rev = version;
    sha256 = "sha256-C11HpftrYOCVyWT31wrqo8FVZuP7mRUkRv5IDeAZ+To=";
  };

  nativeBuildInputs = [ menhir ];

  meta = {
    description = "Date and duration in OCaml";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
