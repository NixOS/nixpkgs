{ lib, buildDunePackage, fetchFromGitHub
, menhir, ppxlib, ppx_deriving, re, uutf, uucp, ounit2
}:

buildDunePackage rec {
  pname = "jingoo";
  version = "1.4.4";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "tategakibunko";
    repo = "jingoo";
    rev = "v${version}";
    sha256 = "sha256-qIw69OE7wYyZYKnIc9QrmF8MzY5Fg5pBFyIpexmaYxA=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ ppxlib ppx_deriving re uutf uucp ];
  checkInputs = [ ounit2 ];
  doCheck = true;


  meta = with lib; {
    homepage = "https://github.com/tategakibunko/jingoo";
    description = "OCaml template engine almost compatible with jinja2";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
