{
  lib,
  fetchurl,
  buildDunePackage,
  ppxlib,
  ppx_repr,
  logs,
}:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "3.9.0";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    hash = "sha256-jgc6vhtf+1ttWMMmBsnX2rwyxTUBdWvoCpLtR3etUaA=";
  };

  minimalOCamlVersion = "4.10";

  propagatedBuildInputs = [
    ppx_repr
    ppxlib
    logs
  ];

  meta = with lib; {
    homepage = "https://irmin.org/";
    description = "PPX deriver for Irmin generics";
    license = licenses.isc;
    maintainers = with maintainers; [
      vbgl
      sternenseemann
    ];
  };
}
