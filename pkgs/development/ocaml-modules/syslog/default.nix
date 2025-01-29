{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "syslog";
  version = "2.0.2";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "geneanet";
    repo = "ocaml-syslog";
    rev = "v${version}";
    hash = "sha256-WybNZBPhv4fhjzzb95E+6ZHcZUnfROLlNF3PMBGO9ys=";
  };

  meta = with lib; {
    homepage = "https://github.com/geneanet/ocaml-syslog";
    description = "Simple wrapper to access the system logger from OCaml";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.rixed ];
  };
}
