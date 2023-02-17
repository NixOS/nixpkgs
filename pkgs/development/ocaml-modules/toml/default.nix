{ lib, fetchFromGitHub, buildDunePackage
, iso8601, menhir
}:

buildDunePackage rec {
  pname = "toml";
  version = "7.1.0";
  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "ocaml-toml";
    repo = "to.ml";
    rev = version;
    hash = "sha256-uk14Py7lEEDJhFsRRtStXqKlJLtx0o8eS9DEIes4SHw=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ iso8601 ];

  meta = {
    description = "Implementation in OCaml of the Toml minimal langage";
    homepage = "http://ocaml-toml.github.io/To.ml";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
