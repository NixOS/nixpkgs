{ lib, buildDunePackage, fetchFromGitHub, ocaml
, menhir, ppxlib, ppx_deriving, re, uutf, uucp, ounit2
}:

buildDunePackage rec {
  pname = "jingoo";
  version = "1.4.4";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "tategakibunko";
    repo = "jingoo";
    rev = "v${version}";
    sha256 = "sha256-qIw69OE7wYyZYKnIc9QrmF8MzY5Fg5pBFyIpexmaYxA=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ ppxlib ppx_deriving re uutf uucp ];
  checkInputs = [ ounit2 ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";


  meta = with lib; {
    homepage = "https://github.com/tategakibunko/jingoo";
    description = "OCaml template engine almost compatible with jinja2";
    mainProgram = "jingoo";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
