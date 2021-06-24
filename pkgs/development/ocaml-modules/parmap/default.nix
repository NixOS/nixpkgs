{ lib, buildDunePackage, fetchurl, dune-configurator }:

buildDunePackage rec {
  pname = "parmap";
  version = "1.2";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/rdicosmo/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "sha256-XUXptzD0eytaypaBQ+EBp4iVFRE6/Y0inS93t/YZrM8=";
  };

  buildInputs = [ dune-configurator ];

  doCheck = true;

  meta = with lib; {
    description = "Library for multicore parallel programming";
    homepage = "https://rdicosmo.github.io/parmap";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
