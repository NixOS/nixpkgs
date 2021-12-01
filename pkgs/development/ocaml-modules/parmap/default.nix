{ lib, fetchurl, buildDunePackage, dune-configurator }:

buildDunePackage rec {
  pname = "parmap";
  version = "1.2.3";

  src = fetchurl {
    url = "https://github.com/rdicosmo/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1wg81slp453jci0gi0rzvdjx74110mlf1n5qpsmxic6fqsyz9d2v";
  };

  minimalOCamlVersion = "4.03";
  useDune2 = true;

  buildInputs = [
    dune-configurator
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library for multicore parallel programming";
    downloadPage = "https://github.com/rdicosmo/parmap";
    homepage = "https://rdicosmo.github.io/parmap";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
