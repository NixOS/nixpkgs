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
  version = "0.1.4";
  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/coin/releases/download/v${version}/coin-${version}.tbz";
    sha256 = "sha256:0069qqswd1ik5ay3d5q1v1pz0ql31kblfsnv0ax0z8jwvacp3ack";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'ocaml} ' \
      'ocaml} -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib '
  '';

  nativeBuildInputs = [ findlib ];
  buildInputs = [ re ];

  doCheck = true;

  meta = {
    description = "A library to normalize an KOI8-{U,R} input to Unicode";
    homepage = "https://github.com/mirage/coin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "coin.generate";
  };
}
