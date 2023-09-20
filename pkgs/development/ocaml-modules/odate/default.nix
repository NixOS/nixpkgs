{ lib, buildDunePackage, fetchFromGitHub
, menhir
}:

buildDunePackage rec {
  pname = "odate";
  version = "0.6";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "hhugo";
    repo = pname;
    rev = version;
    sha256 = "1dk33lr0g2jnia2gqsm6nnc7nf256qgkm3v30w477gm6y2ppfm3h";
  };

  nativeBuildInputs = [ menhir ];

  # Ensure compatibility of v0.6 with menhir ≥ 20220210
  preBuild = ''
    substituteInPlace dune-project --replace "(using menhir 1.0)" "(using menhir 2.0)"
  '';

  meta = {
    description = "Date and duration in OCaml";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
