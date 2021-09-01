{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "routes";
  version = "0.9.1";

  useDune2 = true;
  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/anuragsoni/routes/releases/download/${version}/routes-${version}.tbz";
    sha256 = "0h2c1p5w6237c1lmsl5c8q2dj5dq20gf2cmb12nbmlfn12sfmcrl";
  };

  meta = with lib; {
    description = "Typed routing for OCaml applications";
    license = licenses.bsd3;
    homepage = "https://anuragsoni.github.io/routes";
    maintainers = with maintainers; [ ulrikstrid anmonteiro ];
  };
}
