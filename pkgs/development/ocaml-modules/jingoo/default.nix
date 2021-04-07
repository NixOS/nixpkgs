{ lib, buildDunePackage, fetchFromGitHub
, menhir, ppxlib, ppx_deriving, re, uutf, uucp, ounit2 }:

buildDunePackage rec {
  pname = "jingoo";
  version = "1.4.2";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "tategakibunko";
    repo = "jingoo";
    rev = "v${version}";
    sha256 = "0q947aik4i4z5wjllhwlkxh60qczwgra21yyrrzwhi9y5bnf8346";
  };

  buildInputs = [ menhir ];
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
