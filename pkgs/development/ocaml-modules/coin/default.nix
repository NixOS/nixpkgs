{
  buildDunePackage,
  fetchurl,
  findlib,
  lib,
  ocaml,
  re,
}:

buildDunePackage rec {
  pname = "coin";
  version = "0.1.5";
  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/coin/releases/download/v${version}/coin-${version}.tbz";
    sha256 = "sha256-z2WzQ7zUFmZJTUqygTHguud6+NAcp36WubHbILXGR9g=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'ocaml} ' \
      'ocaml} -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib '
  '';

  nativeBuildInputs = [ findlib ];
  buildInputs = [ re ];

  doCheck = true;

  meta = {
    description = "Library to normalize an KOI8-{U,R} input to Unicode";
    homepage = "https://github.com/mirage/coin";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "coin.generate";
  };
}
