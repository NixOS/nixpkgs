{ lib, buildDunePackage, fetchFromGitHub
, menhir
}:

buildDunePackage rec {
  pname = "odate";
  version = "0.6";

  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "hhugo";
    repo = pname;
    rev = version;
    sha256 = "1dk33lr0g2jnia2gqsm6nnc7nf256qgkm3v30w477gm6y2ppfm3h";
  };

  strictDeps = true;

  nativeBuildInputs = [ menhir ];

  meta = {
    description = "Date and duration in OCaml";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
