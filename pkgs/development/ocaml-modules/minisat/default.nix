{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "minisat";
  version = "0.4";

  useDune2 = true;

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner  = "c-cube";
    repo   = "ocaml-minisat";
    rev    = "v${version}";
    sha256 = "009jncrvnl9synxx6jnm6gp0cs7zlj71z22zz7bs1750b0jrfm2r";
  };

  meta = {
    homepage = "https://c-cube.github.io/ocaml-minisat/";
    description = "Simple bindings to Minisat-C";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
}
