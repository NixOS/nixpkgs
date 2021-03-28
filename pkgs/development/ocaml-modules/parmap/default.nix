{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "parmap";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/rdicosmo/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "sha256-XUXptzD0eytaypaBQ+EBp4iVFRE6/Y0inS93t/YZrM8=";
  };

  doCheck = true;

  meta = with lib; {
    description = "Library for multicore parallel programming";
    homepage = "https://rdicosmo.github.io/parmap";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
