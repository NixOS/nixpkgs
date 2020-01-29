{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "minisat";
  version = "0.2";

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner  = "c-cube";
    repo   = "ocaml-minisat";
    rev    = version;
    sha256 = "1jibylmb1ww0x42n6wl8bdwicaysgxp0ag244x7w5m3jifq3xs6q";
  };

  meta = {
    homepage = https://c-cube.github.io/ocaml-minisat/;
    description = "Simple bindings to Minisat-C";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
}
