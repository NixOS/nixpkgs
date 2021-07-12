{ lib, fetchzip, ppx_deriving, ppxfind, buildDunePackage, ounit }:

buildDunePackage rec {
  pname = "lens";
  version = "1.2.4";

  useDune2 = true;

  src = fetchzip {
    url = "https://github.com/pdonadeo/ocaml-lens/archive/v${version}.tar.gz";
    sha256 = "18mv7n5rcix3545mc2qa2f9xngks4g4kqj2g878qj7r3cy96kklv";
  };

  minimumOCamlVersion = "4.10";
  buildInputs = [ ppx_deriving ppxfind ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = with lib; {
    homepage = "https://github.com/pdonadeo/ocaml-lens";
    description = "Functional lenses";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      kazcw
    ];
    broken = true; # Not compatible with ppx_deriving ≥ 5.0
  };
}
