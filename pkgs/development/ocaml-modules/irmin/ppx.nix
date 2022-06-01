{ lib, fetchurl, buildDunePackage, ppxlib, ppx_repr, logs }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "3.2.1";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "sha256-nPtykafZDKDlXs4zBArUHnTK3YxkRuBMM1WLwaGVFRg=";
  };

  minimumOCamlVersion = "4.10";

  strictDeps = true;

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
