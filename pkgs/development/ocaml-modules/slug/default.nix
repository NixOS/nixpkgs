{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  re,
  uunf,
  uuseg,
  alcotest,
}:

buildDunePackage rec {
  pname = "slug";
  version = "1.0.1";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "thangngoc89";
    repo = "ocaml-slug";
    rev = version;
    sha256 = "sha256-pIk/0asSyibXbwmBSBuLwl2SS9aw6dNDDvwO+1VJGf8=";
  };

  propagatedBuildInputs = [
    re
    uunf
    uuseg
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Url safe slug generator for OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.niols ];
    homepage = "https://github.com/thangngoc89/ocaml-slug";
  };
}
