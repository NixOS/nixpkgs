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
  version = "3.10.0";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    hash = "sha256-kqneegoqNcL+ugw1qAax8N8kwcDRUWTuvz+RkpbSZxU=";
  };

  minimalOCamlVersion = "4.10";

  propagatedBuildInputs = [
    ppx_repr
    ppxlib
    logs
  ];

  meta = {
    homepage = "https://irmin.org/";
    description = "PPX deriver for Irmin generics";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      vbgl
      sternenseemann
    ];
  };
}
