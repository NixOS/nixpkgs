{ lib, buildDunePackage, fetchFromGitHub, ocaml, benchmark }:

buildDunePackage rec {
  version = "0.6.2";
  pname = "rope";

  useDune2 = true;
  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "Chris00";
    repo = "ocaml-rope";
    rev = "${version}";
    sha256 = "1g828n359xzd3zk67kaarypbr861bxqghc3c7q37f5ihqb516bs1";
  };

  buildInputs = [ benchmark ];

  meta = {
    homepage = "http://rope.forge.ocamlcore.org/";
    platforms = ocaml.meta.platforms or [];
    description = ''Ropes ("heavyweight strings") in OCaml'';
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ volth ];
  };
}
