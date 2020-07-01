{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  minimumOCamlVersion = "4.06";
  pname = "owee";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "owee";
    rev = "v${version}";
    sha256 = "0jp8ca57488d7sj2nqy4yxcdpda6sxx51yyi8k6888hbinhyqp0j";
  };

  meta = {
    description = "An experimental OCaml library to work with DWARF format";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
