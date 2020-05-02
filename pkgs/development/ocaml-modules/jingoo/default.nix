{ lib, buildDunePackage, fetchFromGitHub
, menhir, ppx_deriving, re, uutf, uucp, ounit2 }:

buildDunePackage rec {
  pname = "jingoo";
  version = "1.3.4";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "tategakibunko";
    repo = "jingoo";
    rev = "v${version}";
    sha256 = "0fsmm6wxa3axwbcgwdidik3drg754wyh2vxri2w12d662221m98s";
  };

  buildInputs = [ menhir ];
  propagatedBuildInputs = [ ppx_deriving re uutf uucp ];
  checkInputs = [ ounit2 ];
  doCheck = true;


  meta = with lib; {
    homepage = "https://github.com/tategakibunko/jingoo";
    description = "OCaml template engine almost compatible with jinja2";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
