{ lib, buildDunePackage, fetchzip, ocaml, uchar, uutf, ounit2 }:

buildDunePackage rec {
  pname = "markup";
  version = "1.0.0";

  useDune2 = true;

  src = fetchzip {
    url = "https://github.com/aantron/markup.ml/archive/${version}.tar.gz";
    sha256 = "09hkrf9pw6hpb9j06p5bddklpnjwdjpqza3bx2179l970yl67an9";
  };

  propagatedBuildInputs = [ uchar uutf ];

  checkInputs = [ ounit2 ];
  doCheck = lib.versionAtLeast ocaml.version "4.04";

  meta = with lib; {
    homepage = "https://github.com/aantron/markup.ml/";
    description = "A pair of best-effort parsers implementing the HTML5 and XML specifications";
    license = licenses.mit;
    maintainers = with maintainers; [ gal_bolle ];
  };

}
