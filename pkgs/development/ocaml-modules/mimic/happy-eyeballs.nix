{ lib, buildDunePackage, mimic, happy-eyeballs-mirage }:

buildDunePackage rec {
  pname = "mimic-happy-eyeballs";
  minimalOCamlVersion = "4.08";

  inherit (mimic) version src;


  propagatedBuildInputs = [
    mimic
    happy-eyeballs-mirage
  ];

  meta = with lib; {
    description = "A happy-eyeballs integration into mimic";
    license = licenses.isc;
    homepage = "https://github.com/mirage/ocaml-git";
    maintainers = [ maintainers.sternenseemann ];
  };
}
