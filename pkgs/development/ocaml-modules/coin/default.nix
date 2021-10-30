{ buildDunePackage
, fetchzip
, findlib
, lib
, menhir
, ocaml
, re
}:

buildDunePackage rec {
  pname = "coin";
  version = "0.1.3";
  minimalOCamlVersion = "4.03";

  src = fetchzip {
    url = "https://github.com/mirage/coin/releases/download/v${version}/coin-v${version}.tbz";
    sha256 = "06bfidvglyp9hzvr2xwbdx8wf26is2xrzc31fldzjf5ab0vd076p";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'ocaml} ' \
      'ocaml} -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib '
  '';

  useDune2 = true;

  nativeBuildInputs = [ menhir ];

  checkInputs = [ re ];
  doCheck = true;

  meta = {
    description = "A library to normalize an KOI8-{U,R} input to Unicode";
    license = lib.licenses.mit;
    homepage = "https://github.com/mirage/coin";
    maintainers = with lib.maintainers; [ superherointj ];
  };
}
