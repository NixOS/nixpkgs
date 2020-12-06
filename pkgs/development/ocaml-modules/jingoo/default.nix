{ lib, buildDunePackage, fetchFromGitHub
, menhir, ppx_deriving, re, uutf, uucp, ounit2 }:

buildDunePackage rec {
  pname = "jingoo";
  version = "1.4.1";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "tategakibunko";
    repo = "jingoo";
    rev = "v${version}";
    sha256 = "16wzggwi3ri13v93mjk8w7zxwp65qmi1rnng2kpk9vffx5g1kv6f";
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
