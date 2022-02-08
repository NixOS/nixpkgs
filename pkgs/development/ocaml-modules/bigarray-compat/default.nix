{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "bigarray-compat";
  version = "1.0.0";

  useDune2 = true;

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = pname;
    rev = "v${version}";
    sha256 = "06j1dwlpisxshdd0nab4n4x266gg1s1n8na16lpgw3fvcznwnimz";
  };

  meta = {
    description = "Compatibility library to use Stdlib.Bigarray when possible";
    inherit (src.meta) homepage;
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
