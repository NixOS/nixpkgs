{ lib, fetchurl, buildDunePackage, ppxlib, ppx_repr, logs }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "3.4.1";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "sha256-kig2EWww7GgGijhpSgm7pSHPR+3Q5K5E4Ha5tJY9oYA=";
  };

  minimalOCamlVersion = "4.10";

  strictDeps = false; # We must provide nativeCheckInputs as buildInputs because dune builds tests at build time

  propagatedBuildInputs = [
    ppx_repr
    ppxlib
    logs
  ];

  meta = {
    homepage = "https://irmin.org/";
    description = "PPX deriver for Irmin generics";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl sternenseemann ];
  };
}
